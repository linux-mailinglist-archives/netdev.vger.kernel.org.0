Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 009DCD90A4
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405203AbfJPMU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:20:28 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37035 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405189AbfJPMU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 08:20:28 -0400
Received: by mail-wr1-f66.google.com with SMTP id p14so27791007wro.4
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 05:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dmrMhgpUSf60d5nh3MAEGQy/4z6O1wG97cbLuW1Vm/Q=;
        b=Lryg5TbKNuFD1H9KnYSEFIXh7TPiZG5JT6QcacCuclZQ7ucsqtGD2RjLXMfRQNQn11
         4H8eWrGeyw6gS2x8zrZV2LRijZHZHDiWAS/WnxWrN5PilX42PAZxtYhpJffHaZ93Q0Xb
         5yV952iEPXu5/aHNYguUVK3s07QjWaKL860yK9MwH+R94+/TR/9tWxOOY1gav0+m4s/U
         lvNZoW05LWMCbBwqgknxmY8ZP4NZTlosLfG3f18WVt4LJYwYzJNr0WPoF+YeGPyAH+RQ
         aNAel85fvckPLTBuXDBW0+kffLA1BAfpPJuw4dw1Cg57p4zBtdSOr4WtIQnK3hTn9zNn
         y1oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dmrMhgpUSf60d5nh3MAEGQy/4z6O1wG97cbLuW1Vm/Q=;
        b=XXwNOLMacUlPTrSl9Qw66lGMAeoi+QNEwRHowskS0XKHoTy8uFIdHV/L86i12U2BCK
         37+xIwnnE0kkMuqMrV9iamTjOM1OXx5DayIpNAPLwmB5jj0mntM1z/4hAohZL6G7NPse
         BDIs5hUvZq5fIo9BlAVgTRcL5ZFKXHR8HhhBqNSViqvaa2M3v4tTZGrX35MaZRouarKS
         WbMEA9Uh+qKG6tjOS8wqxGDyC5FlPQcoQgLrDE2wbKmwt5j3prNZVCFwB47ZnZgbyT+j
         af7lz95X+DlVzyyJljTy+kejkGTGm+566X+9PpRlseT3xtRkfRAr2vWhof9uDwbIyGhZ
         xjCw==
X-Gm-Message-State: APjAAAUScH2+EJC98qbuRat75oYkZGoBrxAeMW8+3phP4ZhiXSJJLWks
        cXnc6f7z34IN2/4w0MSprnLp4pinGoc=
X-Google-Smtp-Source: APXvYqwfPRjX6bZCyWbED2wZKVclukgcm82IW4MA8rMSeU9WhVqp0vA8KEy24wGzUe87U8Bz3v5M6A==
X-Received: by 2002:adf:e542:: with SMTP id z2mr2327859wrm.338.1571228426355;
        Wed, 16 Oct 2019 05:20:26 -0700 (PDT)
Received: from netronome.com (penelope-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:c685:8ff:fe7c:9971])
        by smtp.gmail.com with ESMTPSA id s12sm26946038wra.82.2019.10.16.05.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 05:20:25 -0700 (PDT)
Date:   Wed, 16 Oct 2019 14:20:23 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
Cc:     linux-kernel@lists.codethink.co.uk,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RFC: Bluetooth: missed cpu_to_le16 conversion in
 hci_init4_req
Message-ID: <20191016122022.kz4xzx4hzmtuoh5l@netronome.com>
References: <20191016113943.19256-1-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016113943.19256-1-ben.dooks@codethink.co.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 12:39:43PM +0100, Ben Dooks (Codethink) wrote:
> It looks like in hci_init4_req() the request is being
> initialised from cpu-endian data but the packet is specified
> to be little-endian. This causes an warning from sparse due
> to __le16 to u16 conversion.
> 
> Fix this by using cpu_to_le16() on the two fields in the packet.
> 
> net/bluetooth/hci_core.c:845:27: warning: incorrect type in assignment (different base types)
> net/bluetooth/hci_core.c:845:27:    expected restricted __le16 [usertype] tx_len
> net/bluetooth/hci_core.c:845:27:    got unsigned short [usertype] le_max_tx_len
> net/bluetooth/hci_core.c:846:28: warning: incorrect type in assignment (different base types)
> net/bluetooth/hci_core.c:846:28:    expected restricted __le16 [usertype] tx_time
> net/bluetooth/hci_core.c:846:28:    got unsigned short [usertype] le_max_tx_time
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Johan Hedberg <johan.hedberg@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-bluetooth@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  net/bluetooth/hci_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 04bc79359a17..b2559d4bed81 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -842,8 +842,8 @@ static int hci_init4_req(struct hci_request *req, unsigned long opt)
>  	if (hdev->le_features[0] & HCI_LE_DATA_LEN_EXT) {
>  		struct hci_cp_le_write_def_data_len cp;
>  
> -		cp.tx_len = hdev->le_max_tx_len;
> -		cp.tx_time = hdev->le_max_tx_time;
> +		cp.tx_len = cpu_to_le16(hdev->le_max_tx_len);
> +		cp.tx_time = cpu_to_le16(hdev->le_max_tx_time);

I would suggest that the naming of the le_ fields of struct hci_dev
implies that the values stored in those fields should be little endian
(but those that are more than bone byte wide are not).

In any case, the question arises as to if this has ever worked on big
endian machines.

>  		hci_req_add(req, HCI_OP_LE_WRITE_DEF_DATA_LEN, sizeof(cp), &cp);
>  	}
>  
> -- 
> 2.23.0
> 
