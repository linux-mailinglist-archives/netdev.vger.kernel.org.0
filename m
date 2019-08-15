Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41538F24E
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 19:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732030AbfHORez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 13:34:55 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]:40768 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfHORez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 13:34:55 -0400
Received: by mail-qt1-f177.google.com with SMTP id e8so3151232qtp.7
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 10:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=z5i1vE/ZknQn/4g4X5UqPl8UeiVYJlE2OqMk+GT4iPI=;
        b=D/+ZdVBY5XigTf+yFuVFXAWLKedCrggwz/QxKU/BbgVqEFv5vW2JIusbi/m9BUDYAu
         sspS6DW0cagIYxySTPMfoQN9cIoBZ5ikpw9XQrNk2anOcz1MXXYRcYp9xz4zRuUDVJTT
         bUkCRaabCeaU/lLwSpaezYhLE+uWGn7CvTcJual1nYxBblu/3zOigBtBisRJBydOifHB
         1RdgVElbGnN+SEectQ9YyoEIai6cDWqVzckmxn2iUQxY7CmG/twius+oBvZKIkfnzHjk
         7mqMLSCSbVS5iCuo0q3sRGOhBN4gj3YighydC7E8n/O4Al35IUjGz+ZS6bFY6NwPbhvb
         Z34A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=z5i1vE/ZknQn/4g4X5UqPl8UeiVYJlE2OqMk+GT4iPI=;
        b=uO65yk6QOev5PWZPU6cKPoAPASyGh0TOdnb0JQRRQ6GIixirnkuOZj9XfHFtxVfJUI
         yQqp2avsEq4XCXJvKBEVeiya9KiPUAVwXvS+4x0GKFYWKqYvAELZPnbgy61mVrq2zHVm
         r9Ob8Ip01ce8af8sAVGl58X4wWiZljhuy1suIK4meoOZmc4uEf/5dRG9jcqIMuIo2wbf
         QP7S7rdNhdGHdIWT7ZsMXZTQ4qNiQPfC/B0RUnxEcgPjcy7zIimAwenuygIVyurHaGtH
         XW3IkAgFp15OlAE0qGJzLOw67T65wd8k51R3lb5aHVfKvEJDAh9/dW4ETyeo+q1i+yrV
         tbew==
X-Gm-Message-State: APjAAAWkJUYXkJ1wERpSXsykZd7NQQd9w3/37BK7UCWo6WZzWFcsnfdy
        3kYjtjAHaZhvWUi1DVq1M/oYyQ==
X-Google-Smtp-Source: APXvYqxD8fjV0NCxNUkjgxp3QfZqk++Z5HpB8xb//rwRpTVH+SV+M+OXg0xylSacRr4KUv69gYSErQ==
X-Received: by 2002:ac8:73d5:: with SMTP id v21mr4994605qtp.23.1565890494048;
        Thu, 15 Aug 2019 10:34:54 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x69sm1832184qkb.4.2019.08.15.10.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 10:34:53 -0700 (PDT)
Date:   Thu, 15 Aug 2019 10:34:40 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next v4 2/2] selftests: netdevsim: add devlink
 regions tests
Message-ID: <20190815103440.233da551@cakuba.netronome.com>
In-Reply-To: <20190815134634.9858-3-jiri@resnulli.us>
References: <20190815134634.9858-1-jiri@resnulli.us>
        <20190815134634.9858-3-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Aug 2019 15:46:34 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Test netdevsim devlink region implementation.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Tested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Thank you!!
