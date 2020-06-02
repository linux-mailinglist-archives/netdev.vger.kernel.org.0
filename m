Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F611EBFC5
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 18:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgFBQRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 12:17:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbgFBQRC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 12:17:02 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3DE6206E2;
        Tue,  2 Jun 2020 16:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591114622;
        bh=5B6Ig6Gy857CuHoNuQS9dtVgymR447DlKdc8pks5fYQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oGVnwKrZ4tD1qFDG4w6lTXp2cZflwTuq0bL4HFDd28rTzBxsGqhaU92IhAagIdm4r
         FNVBSK7Pn68LTYw/IX5kYJxjs652Hh7nhQSPEgVWOnnvbTGyN1uonRam7NXp5IhfG8
         vaxjbGkarI9dZzcKUwAyIYS0QEG0hRhplCqHkDPo=
Date:   Tue, 2 Jun 2020 09:17:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        vinicius.gomes@intel.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        linux-devel@linux.nxdi.nxp.com
Subject: Re: [PATCH v2 net-next 06/10] net: mscc: ocelot: VCAP ES0 support
Message-ID: <20200602091700.6b476c80@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200602051828.5734-7-xiaoliang.yang_1@nxp.com>
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
        <20200602051828.5734-7-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Jun 2020 13:18:24 +0800 Xiaoliang Yang wrote:
> VCAP ES0 is an egress VCAP working on all outgoing frames.
> This patch added ES0 driver to support vlan push action of tc filter.
> Usage:
> 	tc filter add dev swp1 egress protocol 802.1Q flower skip_sw
> 	vlan_id 1 vlan_prio 1 action vlan push id 2 priority 2
> 
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

Please make sure code builds cleanly with W=1 C=1 flags.

drivers/net/dsa/ocelot/felix_vsc9959.c:577:19: warning: symbol 'vsc9959_vcap_es0_keys' was not declared. Should it be static?
drivers/net/dsa/ocelot/felix_vsc9959.c:588:19: warning: symbol 'vsc9959_vcap_es0_actions' was not declared. Should it be static?
