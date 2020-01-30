Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8915C14DD79
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 16:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgA3PB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 10:01:58 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46836 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgA3PB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 10:01:57 -0500
Received: by mail-pg1-f193.google.com with SMTP id z124so1765338pgb.13;
        Thu, 30 Jan 2020 07:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=taXx+ntK4GyiVfQ3GXRjKHqsGEpKX33UOGmexQOYw6g=;
        b=Bv0Vc4HY0jMs32vYmT5Wkh5RlSLywxFvOyqwUAax7QzIm9W3o7HvGJRBu5/9OdK1Ja
         XoKsoQPPrBoZXLOcF9gWbqYygavumFBdYqZMlfOBN68cSOU4Vzem3DZH3sjZFZKaRvU0
         fy1gUGNFH9OxDax3GYrdBzKbU81EQVfLJP2NsbRyWG0SHnLtcbUhyd+rMqiZT7D0s7rd
         OmJh85q/oughbIgHyazE7WvZx4YzJWmVmDGG+ZHh+QaY2IkiPGmndb2+E5kx7X0iHxBe
         /+YIIAuoQQEMb8LpxQID1FkTIbW4fY47e6jvkpHMtJXOmda+1esmnEqE9YxssZ4Xgi8Y
         xnHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=taXx+ntK4GyiVfQ3GXRjKHqsGEpKX33UOGmexQOYw6g=;
        b=YtzH80Rn2XvZ1zxSsQ/ghk5uf4CuwGI7ptoSdTbUGTsqbIjQi/joMeNJN6+PGsuzxB
         Yoo5RuowBgBHQnNjfbSXxyX1jxx8skcZeobnNi5AkQmAEFytFrPC6chESJw78OGbYakK
         ltO1dyhQHM+O7YXWLpz9xfvSJQDuBzPenXJuldveqJWg0pSxfYWexD42atED/g8oT17m
         cVpCFmtif4+NY/iuYyqvBwh/En5rd6asW3/Ej+x6XxF3ZA5ms1C/1I88WGJu6+7gR2P8
         jvDoB22UK2RxeiCLFNUP239gmHod5QX4ZGPrLJFseWaqnnIUm+40gIffxRqXlWEOZJcv
         dgUw==
X-Gm-Message-State: APjAAAU2oxZPE5S7hQsvoZagSozDPY7CZDYz24r3ZnTdrDsb1CFmez6C
        3/ADzt3EtpHalno3/FuXXFg=
X-Google-Smtp-Source: APXvYqzPA/x6bG2eMMow7olzd0KpNzfQERCi5MAiCXV1A6uYdNrOnsiOgrBC96e/CeW/r3XPRDvwtg==
X-Received: by 2002:a65:4242:: with SMTP id d2mr5196624pgq.166.1580396516645;
        Thu, 30 Jan 2020 07:01:56 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id ep2sm6743362pjb.31.2020.01.30.07.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2020 07:01:55 -0800 (PST)
Date:   Thu, 30 Jan 2020 07:01:53 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     min.li.xe@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptp: Add a ptp clock driver for IDT 82P33 SMU.
Message-ID: <20200130150153.GB1477@localhost>
References: <1580326638-5455-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580326638-5455-1-git-send-email-min.li.xe@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The net-next tree is closed for new submissions until after the
mainline merge window closes.  So you will have to re-submit this
patch then.

This patch and the first one should have [net-next] in the subject
line.  Please address both messages (1/2 and 2/2) to the netdev list,
with the others on CC.

But for, here are a few coding style issues...

On Wed, Jan 29, 2020 at 02:37:18PM -0500, min.li.xe@renesas.com wrote:
> @@ -12,4 +12,5 @@ obj-$(CONFIG_PTP_1588_CLOCK_KVM)	+= ptp_kvm.o
>  obj-$(CONFIG_PTP_1588_CLOCK_QORIQ)	+= ptp-qoriq.o
>  ptp-qoriq-y				+= ptp_qoriq.o
>  ptp-qoriq-$(CONFIG_DEBUG_FS)		+= ptp_qoriq_debugfs.o
> -obj-$(CONFIG_PTP_1588_CLOCK_IDTCM)	+= ptp_clockmatrix.o
> \ No newline at end of file

Please fix white space here

> +obj-$(CONFIG_PTP_1588_CLOCK_IDTCM)	+= ptp_clockmatrix.o
> +obj-$(CONFIG_PTP_1588_CLOCK_IDT82P33)	+= ptp_idt82p33.o
> \ No newline at end of file

and here.

> +static void _idt82p33_caps_init(struct ptp_clock_info	*caps)
> +{

No need for leading _ on private methods.

> +	(caps)->owner = THIS_MODULE;
> +	(caps)->max_adj = 92000;
> +	(caps)->adjfreq = idt82p33_adjfreq;
> +	(caps)->adjtime = idt82p33_adjtime;
> +	(caps)->gettime64 = idt82p33_gettime;
> +	(caps)->settime64 = idt82p33_settime;
> +	(caps)->enable = idt82p33_enable;
> +}
> +
> +static int _mask_bit_count(int mask)
> +{

There is a GCC built in for this.

> +	int ret = 0;
> +
> +	while (mask != 0) {
> +		mask &= (mask-1);
> +		ret++;
> +	}
> +
> +	return ret;
> +}
> +
> +static void _byte_array_to_timespec(struct timespec64 *ts,
> +				u8 buf[TOD_BYTE_COUNT])
> +{

Prefix all your functions with idt82p33_ please.

> +	u8 i;
> +	s32 nsec;
> +	time64_t sec;
> +
> +	nsec = buf[3];
> +	for (i = 0; i < 3; i++) {
> +		nsec <<= 8;
> +		nsec |= buf[2 - i];
> +	}
> +
> +	sec = buf[9];
> +	for (i = 0; i < 5; i++) {
> +		sec <<= 8;
> +		sec |= buf[8 - i];
> +	}
> +
> +	ts->tv_sec = sec;
> +	ts->tv_nsec = nsec;
> +}

Thanks,
Richard
