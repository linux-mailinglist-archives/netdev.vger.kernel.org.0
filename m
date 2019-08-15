Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5331F8F24B
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 19:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731812AbfHOReW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 13:34:22 -0400
Received: from mail-qk1-f172.google.com ([209.85.222.172]:44077 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbfHOReV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 13:34:21 -0400
Received: by mail-qk1-f172.google.com with SMTP id d79so2428453qke.11
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 10:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=N3Ki0MTL20CU95gWwqFQ1mGA93eCFRo+78S+4MUGlZ8=;
        b=UOGpt48sj+Rs3zAIQpkiLlWHkcPlZgFL2kLNzn678BdH6WCVSmu3OCrMQKN79E0YHF
         XQ5KUiXI/UBKUiy54D0ncwaaBI7Fdmy3alJbRiFWUd6L+ZRfz4ErZPKq9X51W67gAKhL
         EP+oLlO52+n3N1lfOqYmNnIf/8LU4vNJ46B09hqA+ngBfdRtOjZ9oWmNmL3qY/bH/B98
         MgHLYxhXHP0/OZmP8Q6DmbM8uMTys+U4AJFp1fTij8BxM/+xhY+RostKEYd+JTrgm/Tm
         Smx/W9I/hWZB+Y8JbN1VQFUQopWlypy9HC6b7YLlmtQ7xT4DjrYzpkVHRDurU2Uzg0Sn
         Hkgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=N3Ki0MTL20CU95gWwqFQ1mGA93eCFRo+78S+4MUGlZ8=;
        b=JDAtduX+fFeVCMH74uGbnxENK+sy9JhrhL59kJiJ+0QD7cixPCJcNzlJWFkecGL7bL
         uMIJpSBN5OVd0cyBCoDMt1ODZJMgQuCGhOT2RcsZp9oqm/7z/3rEJpjFn+MtPg8T61Um
         iL8SyUADtE+8RU5QO0LeMlTTcdGLbHHRlW/KyBJIq6mShABREWSmCK4lolUv4oSYD4/Y
         zSqqs+s1lZ8MT3UYrNqm45wgOHEz18ONKgFnFIiLiMqeLjAfCbpSGxTr14NJFgZpXPKn
         /wde7K6ebGikw0HN/2HFjDm9QshLADXJ0zdjJSAouEr+uzCtUZdT+nTknxoGKzO0nUYA
         jerA==
X-Gm-Message-State: APjAAAVqlennIWBCzFWbDB9Gfs2cbngnRo0Sc+iDjTPYesT/0OxzU3xw
        jdVLTxslE8GPs7UeWGaOu7+TjA==
X-Google-Smtp-Source: APXvYqxCy4OOtWF/3t15pSJn8mq9wL1rUv3MjfCU/SWUdVdya8pFYkhSWvM3TXz4tB7ooI4eQm3aLw==
X-Received: by 2002:a37:a157:: with SMTP id k84mr3459181qke.141.1565890460888;
        Thu, 15 Aug 2019 10:34:20 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 6sm1930069qtu.15.2019.08.15.10.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 10:34:20 -0700 (PDT)
Date:   Thu, 15 Aug 2019 10:34:07 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next v4 1/2] netdevsim: implement support for
 devlink region and snapshots
Message-ID: <20190815103407.4bad07dd@cakuba.netronome.com>
In-Reply-To: <20190815134634.9858-2-jiri@resnulli.us>
References: <20190815134634.9858-1-jiri@resnulli.us>
        <20190815134634.9858-2-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Aug 2019 15:46:33 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Implement dummy region of size 32K and allow user to create snapshots
> or random data using debugfs file trigger.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
