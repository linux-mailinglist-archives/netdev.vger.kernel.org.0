Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4135E1EB6EF
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 10:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgFBIDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 04:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgFBIDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 04:03:32 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E68C061A0E;
        Tue,  2 Jun 2020 01:03:31 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a25so4630917ejg.5;
        Tue, 02 Jun 2020 01:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1AY44KmLVRCM5xh41Rvf/VDESLYAOYBqhtqjiVjW5jM=;
        b=kjeDZk7jLAvQc+9vc6EeQvaUb/kVfkpxiDx5AGwluykW4IY1GIx4P3y5F4s3Cg115f
         dOEXABSI8XJGZ9twRtWibPb1l061xg9K5oLfMmpyBcfulos+GEVATNxmzC+ZpQPpwLY9
         De44Z3tEvWKvPaS55oyJicdSfGPwCNBI16LnxVcc8IgCHdJeM4S9IhFJD2FLmEs81FIs
         s9errf9neBx6ACcJP8trx1VRPsgTXl7qOq40GkmyW2k4fs11iloobVTOuh/wDHuAFrXm
         bmNBCXLsMNnonqduBUKn3uqoT5iYeRjjZT7sJmv65IH7fzDoVms2i/7GuEbPT/b4k4NN
         MJjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1AY44KmLVRCM5xh41Rvf/VDESLYAOYBqhtqjiVjW5jM=;
        b=GBUxT8kJi8IY8gGb9OChU9GWfOR9zoObT6nhTdH/sbIU8YxPg0fGtJDZeuI4Jqh+us
         /eZNd4OFkNCNy5gS+RDtvJ57SiGlhRrThv71o3rEkc2itYVaxN6k0+Zs1KcCW9LoXqKD
         nBfkEKid7EzwyrrUkuopn2ZyAK9uWHlIqEc5pgsMM1A3VlCDArklX8qJN8rq2X48MdQQ
         dhOnNQ45U2NrBj/KMm3PUDIDAkxAy4h3im5Hjwcvgs+s0y5IwUUugpL8eF7APKLgSM4o
         ut98KLpY3S/G3eNwEu7HS45ku5tLGWVYlm1WOAoq4wO7SaganlesRdTBMz3t/fpV+F12
         kYrw==
X-Gm-Message-State: AOAM5300aoOgb3OqLxsVD2DZUE5EBhcKACy0Ie4Q0C1ZuPeEZ1jmNGlB
        A6qcv4HE0JblYKhrzued6fn9I2DgOJhyyjcwThU=
X-Google-Smtp-Source: ABdhPJyeJCmrlfsp3uSOdYlcdNgciETQEIa7NzFFDEZ7l2xveCxijE34cLV3MVMU8l1JnqQyS/h9hf5sMHNADVdK3/E=
X-Received: by 2002:a17:906:198d:: with SMTP id g13mr22026915ejd.281.1591085010567;
 Tue, 02 Jun 2020 01:03:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 2 Jun 2020 11:03:19 +0300
Message-ID: <CA+h21hp5K8BvNSuWKuAc_tVYeLpRUqrZtfvFz+3hdLWcAOfMag@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 00/10] net: ocelot: VCAP IS1 and ES0 support
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     Po Liu <po.liu@nxp.com>, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        linux-devel@linux.nxdi.nxp.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xiaoliang,

On Tue, 2 Jun 2020 at 08:25, Xiaoliang Yang <xiaoliang.yang_1@nxp.com> wrote:
>
> This series patches adds support for VCAP IS1 and ES0 module, each VCAP
> correspond to a flow chain to offload.
>
> VCAP IS1 supports FLOW_ACTION_VLAN_MANGLE action to filter MAC, IP,
> VLAN, protocol, and TCP/UDP ports keys and retag vlian tag,
> FLOW_ACTION_PRIORITY action to classify packages to different Qos in hw.
>
> VCAP ES0 supports FLOW_ACTION_VLAN_PUSH action to filter vlan keys
> and push a specific vlan tag to frames.
>
> Changes since v1->v2:
>  - Use different chain to assign rules to different hardware VCAP, and
>    use action goto chain to express flow order.
>  - Add FLOW_ACTION_PRIORITY to add Qos classification on VCAP IS1.
>  - Multiple actions support.
>  - Fix some code issues.
>
> Vladimir Oltean (3):
>   net: mscc: ocelot: introduce a new ocelot_target_{read,write} API
>   net: mscc: ocelot: generalize existing code for VCAP
>   net: dsa: tag_ocelot: use VLAN information from tagging header when
>     available
>
> Xiaoliang Yang (7):
>   net: mscc: ocelot: allocated rules to different hardware VCAP TCAMs by
>     chain index
>   net: mscc: ocelot: change vcap to be compatible with full and quad
>     entry
>   net: mscc: ocelot: VCAP IS1 support
>   net: mscc: ocelot: VCAP ES0 support
>   net: mscc: ocelot: multiple actions support
>   net: ocelot: return error if rule is not found
>   net: dsa: felix: correct VCAP IS2 keys offset
>
>  drivers/net/dsa/ocelot/felix.c            |   2 -
>  drivers/net/dsa/ocelot/felix.h            |   2 -
>  drivers/net/dsa/ocelot/felix_vsc9959.c    | 202 +++++-
>  drivers/net/ethernet/mscc/ocelot.c        |  11 +
>  drivers/net/ethernet/mscc/ocelot_ace.c    | 729 ++++++++++++++++------
>  drivers/net/ethernet/mscc/ocelot_ace.h    |  26 +-
>  drivers/net/ethernet/mscc/ocelot_board.c  |   5 +-
>  drivers/net/ethernet/mscc/ocelot_flower.c |  95 ++-
>  drivers/net/ethernet/mscc/ocelot_io.c     |  17 +
>  drivers/net/ethernet/mscc/ocelot_regs.c   |  21 +-
>  drivers/net/ethernet/mscc/ocelot_s2.h     |  64 --
>  include/soc/mscc/ocelot.h                 |  39 +-
>  include/soc/mscc/ocelot_vcap.h            | 199 +++++-
>  net/dsa/tag_ocelot.c                      |  29 +
>  14 files changed, 1105 insertions(+), 336 deletions(-)
>  delete mode 100644 drivers/net/ethernet/mscc/ocelot_s2.h
>
> --
> 2.17.1
>

First of all, net-next has just closed yesterday and will be closed
for the following 2 weeks:
http://vger.kernel.org/~davem/net-next.html

Secondly, could you give an example of how different chains could
express the fact that rules are executed in parallel between the IS1,
IS2 and ES0 TCAMs?

Thanks,
-Vladimir
