Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA151CE827
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 00:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgEKWeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 18:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgEKWeG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 18:34:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB9FF2070B;
        Mon, 11 May 2020 22:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589236445;
        bh=xqABZkD71yLUrEiGvEZOMQlMo99AB7+4sfIbsPXURyI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o/47o67y8/TEpiFuiovEvSiJ34a1YNDXJE2qWhAT3TOAxaIfJ8jqO2odIzQaB8nCy
         QYR5mUz8rFqEcTbkxTPOkcH6ijRJ5Zz/JAcGqVk02sLTbAK8ilDWr1qX8xKz+l24Qk
         LJ2mhKKSAwnmCXAj5xVUJeSELvBU3B9rOv6jwIPU=
Date:   Mon, 11 May 2020 15:34:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        linux-devel@linux.nxdi.nxp.com
Subject: Re: [PATCH v1 net-next 3/3] net: dsa: felix: add support Credit
 Based Shaper(CBS) for hardware offload
Message-ID: <20200511153403.7b402433@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200511054332.37690-4-xiaoliang.yang_1@nxp.com>
References: <20200511054332.37690-1-xiaoliang.yang_1@nxp.com>
        <20200511054332.37690-4-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 May 2020 13:43:32 +0800 Xiaoliang Yang wrote:
> +int vsc9959_qos_port_cbs_set(struct dsa_switch *ds, int port,
> +			     struct tc_cbs_qopt_offload *cbs_qopt)

static
