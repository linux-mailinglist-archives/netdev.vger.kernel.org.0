Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2AD39D8CC
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 00:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfHZWFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 18:05:05 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45654 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbfHZWFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 18:05:04 -0400
Received: by mail-qt1-f195.google.com with SMTP id k13so19446652qtm.12
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 15:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=FG+ES+6tmTMV2+SQwitO26i4wehFqsEwfdp9jAt9gbc=;
        b=AsD3InPViV3zyqezZzbw/CKLtX1DYM5Eag4HlsxbqTA7CmTCo76DgGVvD61/TFQAhZ
         DNZF39CU4eSg0wo48G1e88tbMr3RsLD7A4ahG98w9y4xV+/DDJ0lZE33eiCCHP0RFjtd
         aMdQEmJwl97sB+O+LCNVATghD9Fofasu25xREkg5mayOJiY05EorWCEWRg0uKziwa4g2
         69z0YGcLRnWupOPxrEqcQve0B3qRfMIlngca19ON7pQrdeVUEgnRLGHpxaD5Bvr7lQ0x
         /qil3kWfbVU6GSNDSIAz5yoChmaVAEhZzfQO2SHzpFvfDNNEdhTzGr0oP30TXRSq/3Hd
         TmrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=FG+ES+6tmTMV2+SQwitO26i4wehFqsEwfdp9jAt9gbc=;
        b=hWChu3yW6MecF68t8yMGEIMD7DPF6pUZNhyUuStRlcwMmyIu9oWkSs4BKJ8u/dnAnY
         Z42YVOEIlnTb6RSy+xEgiNCI8SUSrm17yK/SloqAQBaBnFWyT9/7Vo55u21oyv4pU42a
         eFpyT7CQAxzJXf0Ss0l2U29DYkf8HQYTPEow3UTlkMGNohu7TQxsCjueXsAipYNz2wS/
         i0gyic36qn3dXlF9LCbVt4wCwSqiEu06SZWP6XZ8FgjMVk447AdeeetbvncoziTsvIpA
         y3sXj2Hb1jg1YE2Dsh2MYKlGDueZ7YuTS5asu4zwriK/n1A4FQFSY5jDUugBkkG35u1M
         JRlQ==
X-Gm-Message-State: APjAAAVsKNmkpgfXx8+KL6/TMTKUnrHTdat9l5C2tF06r1yz8LHVOboE
        XrwLsjeQEDQ17ArO1yV+JQU=
X-Google-Smtp-Source: APXvYqwebMNmW17TXVB9Q23cy3kgm0VFt8/7X8KQrvrXoRXMMS+7WGzkJdhILxpQlGrUVymL0YSzXA==
X-Received: by 2002:aed:3ea1:: with SMTP id n30mr19903246qtf.342.1566857103436;
        Mon, 26 Aug 2019 15:05:03 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id s64sm7447695qke.125.2019.08.26.15.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 15:05:02 -0700 (PDT)
Date:   Mon, 26 Aug 2019 18:05:01 -0400
Message-ID: <20190826180501.GB27244@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Subject: Re: [PATCH net-next v5 6/6] net: dsa: mv88e6xxx: fully support SERDES
 on Topaz family
In-Reply-To: <20190826213155.14685-7-marek.behun@nic.cz>
References: <20190826213155.14685-1-marek.behun@nic.cz>
 <20190826213155.14685-7-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Mon, 26 Aug 2019 23:31:55 +0200, Marek Behún <marek.behun@nic.cz> wrote:
> Currently we support SERDES on the Topaz family in a limited way: no
> IRQs and the cmode is not writable, thus the mode is determined by
> strapping pins.
> 
> Marvell's examples though show how to make cmode writable on port 5 and
> support SGMII autonegotiation. It is done by writing hidden registers,
> for which we already have code.
> 
> This patch adds support for making the cmode for the SERDES port
> writable on the Topaz family, via a new chip operation,
> .port_set_cmode_writable, which is called from mv88e6xxx_port_setup_mac
> just before .port_set_cmode.
> 
> SERDES IRQs are also enabled for Topaz.
> 
> Tested on Turris Mox.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>

Ho this is much clearer now, I realize I got confused by the previous version
of this patch...

As we've seen, .port_set_cmode is only called from mv88e6xxx_port_setup_mac and
.phylink_config_mac, so it is fine to keep this "make writable" code private
to the mv88e6341_port_set_cmode implementation. I will send a follow-up
patch which addresses that and removes the .port_set_cmode_writable operation.


Thank you,

	Vivien
