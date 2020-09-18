Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9646E26FFFB
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 16:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgIROeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 10:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgIROeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 10:34:16 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65D9C0613CE;
        Fri, 18 Sep 2020 07:34:15 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 34so3573484pgo.13;
        Fri, 18 Sep 2020 07:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ehNLFgOehS2khvMlIukM1gipxnVRhru9elJLFFfgkak=;
        b=oYxeoYnBKch1Aje0z2U2aDGmtKIiBXABtgAlWyJPzIkhv/ostG5OgBj3VwAw94rZn9
         0GWJmpaVgsf7N4FfyW8DJZKTWDCSJkqhd8UaWQipy3V5JfOTNhUx14gY4/iJ1cDrYJY1
         ldDVp8WZQznZy1QHBcP0kk0HauTsB+3dDM9E2IgB40z/COCeudd/Wd9eYmxmPxOV2lZj
         RBdWwbmfuKSMymPfMVs9ibM3oGIAcXgSWTwHYJdIMD8aJTgmZxWMSp+KnAcXAKcWquT5
         YX5zMtnBDL0x0sSMYQxVKNkGEkERKuyjuY1wl1gFMV+ujbsFup8gh75S6UZ5azYUqzWD
         q3zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ehNLFgOehS2khvMlIukM1gipxnVRhru9elJLFFfgkak=;
        b=caeRSguExBjR2keO7CyZeTHmbtdmZ5K6F0oOCARseCLVZ/Dh2u/OveIJGABPHA/L/o
         c/ZSS7mowByiWzNfMgV4MsTnTkc7056BnF/7R8dj1ltiPz+BFfb/OUTk4HZxUJrnsNEq
         3l35QPQbDtbOC6KAbrus2rDGln2OinNvsRo98ny62AwUC8wR3uURVKT4OGRdq5tmMbaY
         jBbjag5Vzp/fnHF7nly8y2bP8Qh0RRdfYm2XzwdfbjOTTe+LvVmmWe3g/GzXPyFE24GJ
         E11TClG6zn+bVH3ppAsKKqGX/Wp71N6n1iTCDfwHWckkwmB+Ob80aGIOCiFaBYXJPkk/
         78oQ==
X-Gm-Message-State: AOAM530hMWpdnTnMLy/418M4j48yfzWzV889ub2u+Wid4snwCc4w6cfr
        17Yuu+7Qz+a5LvoTQ1AP6As=
X-Google-Smtp-Source: ABdhPJzDF9lRYLRj0s6ccVVV7B8TgmkiEd7RYbcfJTBfud5WgKdgJTk2HyKoJqDlssIU+2KeW5H7UQ==
X-Received: by 2002:aa7:8ec7:0:b029:13e:d13d:a137 with SMTP id b7-20020aa78ec70000b029013ed13da137mr32547044pfr.31.1600439655322;
        Fri, 18 Sep 2020 07:34:15 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id l1sm3600902pfc.164.2020.09.18.07.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 07:34:14 -0700 (PDT)
Date:   Fri, 18 Sep 2020 07:34:12 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Herrington <hankinsea@gmail.com>
Cc:     leonro@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ptp: mark symbols static where possible
Message-ID: <20200918143412.GC25831@hoboy>
References: <20200918100943.1740-1-hankinsea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918100943.1740-1-hankinsea@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 06:09:43PM +0800, Herrington wrote:
> diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
> index d3e8ba5c7125..5db4b8891b22 100644
> --- a/include/linux/ptp_clock_kernel.h
> +++ b/include/linux/ptp_clock_kernel.h
> @@ -307,4 +307,13 @@ static inline void ptp_read_system_postts(struct ptp_system_timestamp *sts)
>  		ktime_get_real_ts64(&sts->post_ts);
>  }
>  
> +void pch_ch_control_write(struct pci_dev *pdev, u32 val);
> +u32 pch_ch_event_read(struct pci_dev *pdev);
> +void pch_ch_event_write(struct pci_dev *pdev, u32 val);
> +u32 pch_src_uuid_lo_read(struct pci_dev *pdev);
> +u32 pch_src_uuid_hi_read(struct pci_dev *pdev);
> +u64 pch_rx_snap_read(struct pci_dev *pdev);
> +u64 pch_tx_snap_read(struct pci_dev *pdev);
> +int pch_set_station_address(u8 *addr, struct pci_dev *pdev);

NAK.  Please see Jacob's comment on the origin patch.

Thanks,
Richard
