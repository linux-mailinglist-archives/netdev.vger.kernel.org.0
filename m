Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4990E13CB2F
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 18:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgAORlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 12:41:05 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46422 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAORlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 12:41:05 -0500
Received: by mail-wr1-f66.google.com with SMTP id z7so16559887wrl.13;
        Wed, 15 Jan 2020 09:41:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/3QiPe/1GTUh4wvN6iqGkoCNxlqFn5o7CgcBx+S+Yxk=;
        b=GJtdmt3vEfdhcaXDMtYuiGl4zqCoOsn5TSyZ8GuRgzJyfl/LRCfzBQ/DzO1aGt+K08
         MdEX0EWZghG3xOPRlpo2kv9NEn9g2yjW7WZ477GpO3MU0yTVXD4pzzIV4qGZGOBQrH/p
         knmMq8eSNdjf4HqRLUfr5c6gRIMLVVTYFK4iq5HK20r7usUlneIf1izMzZ7C3QrX+9M2
         dvm4GP00cNivD117I26yL058vuZ38TfuvoXVMV+qaD9UiJPimwZxJRLkWl/FW1yzle1/
         O6z1+qNtFg1hexDjR5nPpxuVvzTjUZZcrY/PZ8lMaubp9xGup5sW0dk08t3s1cC+XHq2
         Obyw==
X-Gm-Message-State: APjAAAVS/H1c6nrLChLwXutelHXOqiZtoKSfcN464L6TzgWJp6S12+Vo
        wuLD9X+11fJYgpdJaUTGM+I=
X-Google-Smtp-Source: APXvYqxTYlzZo5YP/kkwcJuy6q+2a5/NGOs+rhKjCJpOF46IvaQDw/+OQGyFX5tcR/JRocaQUcyDDQ==
X-Received: by 2002:adf:f10a:: with SMTP id r10mr32438058wro.202.1579110063663;
        Wed, 15 Jan 2020 09:41:03 -0800 (PST)
Received: from debian (41.142.6.51.dyn.plus.net. [51.6.142.41])
        by smtp.gmail.com with ESMTPSA id i10sm25964672wru.16.2020.01.15.09.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 09:41:03 -0800 (PST)
Date:   Wed, 15 Jan 2020 17:41:01 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     madhuparnabhowmik04@gmail.com
Cc:     wei.liu@kernel.org, paul@xen.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@kernel.org, joel@joelfernandes.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] net: xen-netback: hash.c: Use built-in RCU list checking
Message-ID: <20200115174101.vqtsil6akmmyv3o4@debian>
References: <20200115155553.13471-1-madhuparnabhowmik04@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115155553.13471-1-madhuparnabhowmik04@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 09:25:53PM +0530, madhuparnabhowmik04@gmail.com wrote:
> From: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>
> 
> list_for_each_entry_rcu has built-in RCU and lock checking.
> Pass cond argument to list_for_each_entry_rcu.
> 
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>

Acked-by: Wei Liu <wei.liu@kernel.org>
