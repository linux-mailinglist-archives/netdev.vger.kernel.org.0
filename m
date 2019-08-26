Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE15B9D249
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 17:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730810AbfHZPGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 11:06:49 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38186 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730033AbfHZPGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 11:06:48 -0400
Received: by mail-qt1-f195.google.com with SMTP id q64so6501767qtd.5
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 08:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=40ZOJyTF4jin/IOzitSI72ErsmGz0gzxhCekirqLMeE=;
        b=AsuYjQ/ERqoxn1DPx869fVf/dcGHPJ9qEN8LP1RRywlWBGNKu1+TX1ujCQwzP1cICS
         SgWAuwPft0PP9HdtOtyHv9xUQ903tysXmbSvzMlF2Frnpt9ENzs7obZAi9YapFKu46Dy
         MXlPvZcGsZt54zS6/wvU/MQfu7oCeelmpAw5gqUlXF7MST4WBRvMRR1KuF4WINpQHFxo
         ZYNGo6UwuQ867xxRwZ+Whn+WMtl2F7kpti/KPynXM0YjoZuszNSL3K9lqNbIqFVzQhZD
         mS3h4yagB3mSS7mVxr6XoqYOSoxoxrwjumL8c7+rVxTDeQGoUTUoMKUM/N2svSAo9t9Z
         EYPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=40ZOJyTF4jin/IOzitSI72ErsmGz0gzxhCekirqLMeE=;
        b=fW4kVkF3uRAQR4moSdf3NK8WxBKwk1dCB4bykEjCQPLBBqgF8OgIiNb6Uz3nNxQAZU
         CUZKdueBsjnIO5e3LovR1fNEXZBER7AVz0VV8FlubACIwDb3o9DgCfHMlBk7Zc4LkGOV
         KU58DtBDNbKKTUP46L0trjJs76lfsa+el3/va9SsKfutpxqjKGDKr3zN/dR+k+7LXYzJ
         oK2Hjh+lpUqgu2L+jjkZbaQs2qHA33o4oZBC+Gzrr0Qu6dUloJHv3K0qjs00I6pQhhYd
         uOjVOgMdbiZ0Pv35qBtIC/wOaexRgBWZguwHpiudef3YyoDFG9scn/ualMP+gty6UTSx
         +HAQ==
X-Gm-Message-State: APjAAAX1/xQI/YOvZFmt0LCoKktrU9iEvyF6EWN5PCRMtkm8GVFQKmWb
        uaE1yqRBB1cw7kSCKVE3Ynh5S6eg
X-Google-Smtp-Source: APXvYqzWhWYehNG5ICRVM6ow6ckTNaasRAZ5g8PfUUPSwOCjJNc/gGAx4ID8qUES33xeXoYINZ6ShQ==
X-Received: by 2002:a0c:8c0b:: with SMTP id n11mr15398462qvb.66.1566832008027;
        Mon, 26 Aug 2019 08:06:48 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 1sm7553828qko.73.2019.08.26.08.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 08:06:46 -0700 (PDT)
Date:   Mon, 26 Aug 2019 11:06:45 -0400
Message-ID: <20190826110645.GB7906@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Subject: Re: [PATCH net-next v4 0/6] net: dsa: mv88e6xxx: Peridot/Topaz SERDES
 changes
In-Reply-To: <20190826122109.20660-1-marek.behun@nic.cz>
References: <20190826122109.20660-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Mon, 26 Aug 2019 14:21:03 +0200, Marek Behún <marek.behun@nic.cz> wrote:
> Hello,
> 
> this is the fourth version of changes for the Topaz/Peridot family of
> switches. The patches apply on net-next.
> Changes since v3:
>  - there was a mistake in the serdes_get_lane implementations for
>    6390 (patch 3/6). These methods returned -ENODEV if no lane was
>    to be on port, but they should return 0. This is now fixed.
> 
> Tested on Turris Mox with Peridot, Topaz, and Peridot + Topaz.
> 
> Marek
> 
> Marek Behún (6):
>   net: dsa: mv88e6xxx: support 2500base-x in SGMII IRQ handler
>   net: dsa: mv88e6xxx: update code operating on hidden registers
>   net: dsa: mv88e6xxx: create serdes_get_lane chip operation
>   net: dsa: mv88e6xxx: simplify SERDES code for Topaz and Peridot
>   net: dsa: mv88e6xxx: rename port cmode macro
>   net: dsa: mv88e6xxx: fully support SERDES on Topaz family
> 
>  drivers/net/dsa/mv88e6xxx/Makefile      |   1 +
>  drivers/net/dsa/mv88e6xxx/chip.c        |  88 +++-----
>  drivers/net/dsa/mv88e6xxx/chip.h        |   3 +
>  drivers/net/dsa/mv88e6xxx/port.c        |  98 ++++++---
>  drivers/net/dsa/mv88e6xxx/port.h        |  30 ++-
>  drivers/net/dsa/mv88e6xxx/port_hidden.c |  70 ++++++
>  drivers/net/dsa/mv88e6xxx/serdes.c      | 275 +++++++++++-------------
>  drivers/net/dsa/mv88e6xxx/serdes.h      |  27 ++-
>  8 files changed, 333 insertions(+), 259 deletions(-)
>  create mode 100644 drivers/net/dsa/mv88e6xxx/port_hidden.c

The series causes no issues on my Dev C with two 88E6390Xs. If Andrew has
no complaints about the functional changes on the SERDES code, this LGTM:

Tested-by: Vivien Didelot <vivien.didelot@gmail.com>


Thanks,

	Vivien
