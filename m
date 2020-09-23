Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADB9275A94
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 16:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgIWOqf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 23 Sep 2020 10:46:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52075 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgIWOqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 10:46:34 -0400
Received: from mail-pg1-f200.google.com ([209.85.215.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1kL62R-0008L8-Ey
        for netdev@vger.kernel.org; Wed, 23 Sep 2020 14:46:31 +0000
Received: by mail-pg1-f200.google.com with SMTP id e28so151172pgm.15
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 07:46:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=IRV4DsqTHJS4UCf0ZaCBRMDHJJpdRDGlcpY0NuGhQ7g=;
        b=X6jgmm8Ikhoy5HYSlLb7xFlc4EV9aHcqeuLc8rAvRjtezKDUTo++dA9yMIpx7sFO6D
         MFikQeZwXTNWuLb8CZ+jxCfBI9XqJVbWq2XLlxucG7emGQ4wWwpQpU/Bqy5KkW2k7uEM
         o1J66fCQrZf72CrgvTmzAAyeUtPgQI+G+I++rjXHqufQ9Sw1HqscdjU2AU1R+8juGNM2
         rnSS2YaD984/Znz0o1oKgk6mrTHn6l8BkNYmHoAW0RI5VGAGnZM7lgKiku1Jtwlub2gG
         lxK3bm5l/UDVsqo8W3I8WnfL76MWdUk9EwqWut9d1qpUpTmbFtsOdOd3xKFD5Uc2rJ1c
         Te6g==
X-Gm-Message-State: AOAM532KK9MooViwvrmNIq4XD71S/faTnkUpejad1MBY9lbSdhyrxSLb
        +8zsa3vIGSi3Jr6xH7eEcDK+AcXjcCY8jEPlxAyTWnETZofXoOXNl/KZPM0F+5WVwRmi14r9Gnu
        DeQpx0NCqSqQcmki2dOsuS+M9dP5I5/ILaQ==
X-Received: by 2002:a63:7d5a:: with SMTP id m26mr66983pgn.373.1600872389147;
        Wed, 23 Sep 2020 07:46:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEca3T4aPQaV9RL6AocGE0yU0atcnRNqviEk4KyxvvK1PiNJGTRuAf0er4y9Q9pep6pePjdg==
X-Received: by 2002:a63:7d5a:: with SMTP id m26mr66963pgn.373.1600872388857;
        Wed, 23 Sep 2020 07:46:28 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id t10sm217313pgp.15.2020.09.23.07.46.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 07:46:28 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Power cycle phy on PM resume
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <17092088-86ff-2d31-b3de-2469419136a3@molgen.mpg.de>
Date:   Wed, 23 Sep 2020 22:46:25 +0800
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <AC6D77B8-244D-4816-8FFE-A4480378EC4C@canonical.com>
References: <20200923074751.10527-1-kai.heng.feng@canonical.com>
 <17092088-86ff-2d31-b3de-2469419136a3@molgen.mpg.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

> On Sep 23, 2020, at 21:28, Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> 
> Dear Kai-Heng,
> 
> 
> Am 23.09.20 um 09:47 schrieb Kai-Heng Feng:
>> We are seeing the following error after S3 resume:
>> [  704.746874] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>> [  704.844232] e1000e 0000:00:1f.6 eno1: MDI Write did not complete
>> [  704.902817] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>> [  704.903075] e1000e 0000:00:1f.6 eno1: reading PHY page 769 (or 0x6020 shifted) reg 0x17
>> [  704.903281] e1000e 0000:00:1f.6 eno1: Setting page 0x6020
>> [  704.903486] e1000e 0000:00:1f.6 eno1: writing PHY page 769 (or 0x6020 shifted) reg 0x17
>> [  704.943155] e1000e 0000:00:1f.6 eno1: MDI Error
>> ...
>> [  705.108161] e1000e 0000:00:1f.6 eno1: Hardware Error
>> Since we don't know what platform firmware may do to the phy, so let's
>> power cycle the phy upon system resume to resolve the issue.
> 
> Is there a bug report or list thread for this issue?

No. That's why I sent a patch to start discussion :)

> 
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> ---
>>  drivers/net/ethernet/intel/e1000e/netdev.c | 2 ++
>>  1 file changed, 2 insertions(+)
>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
>> index 664e8ccc88d2..c2a87a408102 100644
>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
>> @@ -6968,6 +6968,8 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
>>  	    !e1000e_check_me(hw->adapter->pdev->device))
>>  		e1000e_s0ix_exit_flow(adapter);
>>  +	e1000_power_down_phy(adapter);
>> +
>>  	rc = __e1000_resume(pdev);
>>  	if (rc)
>>  		return rc;
> 
> How much does this increase the resume time?

I didn't measure it. Because for me it's more important to have a working device.

Does it have a noticeable impact on your system's resume time?

Kai-Heng

> 
> 
> Kind regards,
> 
> Paul
> 

