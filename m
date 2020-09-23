Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8DA275B9D
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 17:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgIWPWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 11:22:43 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:34512 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgIWPWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 11:22:42 -0400
X-Greylist: delayed 713 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2020 11:22:39 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1600874558;
        s=strato-dkim-0002; d=reintjes.nrw;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=R7hI6d/NmZuNcg1vUXN4expafaD5dS9k1NOlJgVsfQ0=;
        b=mKq3yxzIBoK6eXKDjSaCRr3BwBIqpDKeJr75f5YQmPBPRRn9qdkRISKeudlw+eJUaN
        i9j0YoD7Nd07ieGLh8UqSmYZ1Ccml4PGsZ2Mglopdz9Hz5rLCJkN670J1l7AKyk9w16x
        a5x5cVcgZWQk6FXpa0G8mlW7WSJEKPFpozzrnE9Mqlay09jPyJDrOXyUKIYtt6nlhpnO
        Iws66XTKRoaWIH3voDt0xHa2loKeKKkr2KuI9gRfjll43rW7LApn0Q1chdN5eLyO3daW
        Z1KVrRhdU65Y8/6yfAJtnadI1+vhAkdCKhH0qGquacG5znElBXtRT3qPa76R5ygpIUbq
        FhJQ==
X-RZG-AUTH: ":IGUXYVP6Ne1lB7nQNv+YSUx4qaxF0YAcTeeZr8criwvl+4OoAsy1YB7b8FzONHo5ckdw3KGGkZZ/Zu8="
X-RZG-CLASS-ID: mo00
Received: from [192.168.0.198]
        by smtp.strato.de (RZmta 46.10.7 DYNA|AUTH)
        with ESMTPSA id Y04b60w8NFAYy22
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 23 Sep 2020 17:10:34 +0200 (CEST)
Subject: Re: [PATCH 00/14] drop double zeroing
To:     Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        Julia Lawall <Julia.Lawall@inria.fr>
Cc:     linux-serial@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-media@vger.kernel.org, linux-block@vger.kernel.org,
        Yossi Leybovich <sleybo@amazon.com>,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        rds-devel@oss.oracle.com
References: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
 <160070750168.56292.17961674601916397869.b4-ty@kernel.org>
From:   Rolf Reintjes <lists2.rolf@reintjes.nrw>
Message-ID: <c3b33526-936d-ffa4-c301-4d0485822be1@reintjes.nrw>
Date:   Wed, 23 Sep 2020 17:10:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <160070750168.56292.17961674601916397869.b4-ty@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Mark,

On 21.09.20 18:58, Mark Brown wrote:
> On Sun, 20 Sep 2020 13:26:12 +0200, Julia Lawall wrote:
>> sg_init_table zeroes its first argument, so the allocation of that argument
>> doesn't have to.
> 
> Applied to
> 
>     https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next
> 
> Thanks!

I do not understand which of the 14 patches you applied. Your mail 
responds to the 00/14 mail.

Rolf

> 
> [1/1] spi/topcliff-pch: drop double zeroing
>        commit: ca03dba30f2b8ff45a2972c6691e4c96d8c52b3b
> 
> All being well this means that it will be integrated into the linux-next
> tree (usually sometime in the next 24 hours) and sent to Linus during
> the next merge window (or sooner if it is a bug fix), however if
> problems are discovered then the patch may be dropped or reverted.
> 
> You may get further e-mails resulting from automated or manual testing
> and review of the tree, please engage with people reporting problems and
> send followup patches addressing any issues that are reported if needed.
> 
> If any updates are required or you are submitting further changes they
> should be sent as incremental updates against current git, existing
> patches will not be replaced.
> 
> Please add any relevant lists and maintainers to the CCs when replying
> to this mail.
> 
> Thanks,
> Mark
> 

