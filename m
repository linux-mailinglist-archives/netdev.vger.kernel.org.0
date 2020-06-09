Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B38F1F39D9
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 13:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgFILfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 07:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728729AbgFILfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 07:35:51 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FC7C05BD1E;
        Tue,  9 Jun 2020 04:35:51 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id k8so16039433edq.4;
        Tue, 09 Jun 2020 04:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3GKLgi9m7hHA4w9uhGKyQr7NX05qUvTZLk4S931FPYM=;
        b=LFMzSUM8AA6jIHJuzhSflMSKJcV0epp9vpAmPskgARmQOVqJdqwsS3uTFhVjszdG5m
         2/BVCszhYHGUYxnLTNuP8XKsCDUFcIGffotUF4M/6Nfj6sx0EXrWHLXgOl/a8p50cSSF
         OFKtg0xB45L1QGhjWVOEL0GNTwynrypX82Qd2rBYle5j9bA4agUq/EXFy/mknMkuyRIB
         O4W4Zz5uBZGmzhetuD3jovy7ZHyd1sq4Up4buBOJt2m1Cy39BvVslEDu2rthFIoBILtq
         IDSYO4fBEL8ZmLpBqi+XozVIug6dlxDwAjKpk7DSXDSNgReXWOFhRJBOIMXr1grguQ3g
         3ImA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3GKLgi9m7hHA4w9uhGKyQr7NX05qUvTZLk4S931FPYM=;
        b=VITZnNLHX7aMYKTkXGKrQCw6Ps9khadH9Lj6ATWLi8nnjvNUKIM/gtv/J01pTwY5/h
         iNAJUBdAhWMzxYDmmgKT40ZeMPoHvvVcg56kZDrFig4adJpDLjTBx0N+YM70zs3uhNqj
         tNNctIue8Ks1r7ci+RJTFjAhE+QQ78eRTx9ACOIIurUtJrOpFadtF/D1V40VgD9UtgYm
         7FqRgd8CBSucnlXr9LSiOcz8KqVfidJHJNf5aFfa1JDFshiWJiO30jinJm5m1QwGoBpO
         1zgJ+RIU1nmsBpRLa+ZTOLxxlGbgeHT8+PSmxhAz5a2lOVLFQ0MonsUYNlb/Q/QDwTnF
         TJgg==
X-Gm-Message-State: AOAM533fApfynrg+xwdMFf8jRHc1rS0BPB0ttn+ZQ3iRAdgu/vbTviX7
        LTqngPza2WdQM5qzdERbjuOBkWZ0vw/vunZOhMY=
X-Google-Smtp-Source: ABdhPJykjpPs5vfLoL59YFbbxUZOlqaIj1xtUIkg5mLmUOrgafYoa7TVbq7+qPlqul4A8vjq+IQXSZ9ZDzl8kRpvy7Q=
X-Received: by 2002:aa7:dc50:: with SMTP id g16mr18036226edu.318.1591702549991;
 Tue, 09 Jun 2020 04:35:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
 <CA+h21hp5K8BvNSuWKuAc_tVYeLpRUqrZtfvFz+3hdLWcAOfMag@mail.gmail.com> <DB8PR04MB5785D8DA658A4557973EA233F08B0@DB8PR04MB5785.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB5785D8DA658A4557973EA233F08B0@DB8PR04MB5785.eurprd04.prod.outlook.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 9 Jun 2020 14:35:39 +0300
Message-ID: <CA+h21hpK6iuzyVCLbosUSGcdqCERxpE4WbZrgeB1C6sKmSrK2Q@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH v2 net-next 00/10] net: ocelot: VCAP IS1 and ES0 support
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     Po Liu <po.liu@nxp.com>, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
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
        "linux-devel@linux.nxdi.nxp.com" <linux-devel@linux.nxdi.nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xiaoliang,

On Tue, 2 Jun 2020 at 11:50, Xiaoliang Yang <xiaoliang.yang_1@nxp.com> wrot=
e:
>
> Hi Vladimir,
>
> On Tus, 2 Jun 2020 at 16:04,
> > First of all, net-next has just closed yesterday and will be closed for=
 the following 2 weeks:
> > https://eur01.safelinks.protection.outlook.com/?url=3Dhttp:%2F%2Fvger.k=
ernel.org%2F~davem%2Fnet-next.html&amp;data=3D02%7C01% 7Cxiaoliang.yang_1%4=
0nxp.com%7C2fad4495dabc4f4ca5fd08d806cb70af%7C686ea1d3bc2b4c6fa92cd99c5c301=
635%7C0%7C0%7C637266818117666386&amp;sdata=3DziVybWb4HzYXanehF5KwNv5RJL%2BZ=
z6NeFvrZWg657B8%3D&amp;reserved=3D0
> >
> > Secondly, could you give an example of how different chains could expre=
ss the fact that rules are executed in parallel between the IS1,
> > IS2 and ES0 TCAMs?
> >
>
> Different TCAMs are not running in parallel, they have flow order: IS1->I=
S2->ES0. Using goto chain to express the flow order.
> For example:
>         tc qdisc add dev swp0 ingress
>         tc filter add dev swp0 chain 0 protocol 802.1Q parent ffff: flowe=
r skip_sw vlan_id 1 vlan_prio 1 action vlan modify id 2 priority 2 action g=
oto chain 1
>         tc filter add dev swp0 chain 1 protocol 802.1Q parent ffff: flowe=
r skip_sw vlan_id 2 vlan_prio 2 action drop
> In this example, package with (vid=3D1,pcp=3D1) vlan tag will be modified=
 to (vid=3D2,pcp=3D2) vlan tag on IS1, then will be dropped on IS2.
>
> If there is no rule match on IS1, it will still lookup on IS2. We can set=
 a rule on chain 0 to express this:
>         tc filter add dev swp0 chain 0 parent ffff: flower skip_sw action=
 goto chain 1
>
> In addition, VSC9959 chip has PSFP and "Sequence Generation recovery" mod=
ules are running after IS2, the flow order like this: IS1->IS2->PSFP-> "Seq=
uence Generation recovery" ->ES0, we can also add chains like this to expre=
ss these two modules in future.
>

I've been pondering over what is a good abstraction for 802.1CB and I
don't think that it would be a tc action. After reading Annex C "Frame
Replication and Elimination for Reliability in systems" in
8021CB-2017, I think maybe it should be modeled as a stacked net
device a la hsr, but with the ability to add its own stream filtering
rules and actions (a la bridge fdb).
But for the PSFP policers, in principle I think you are correct, we
could designate a static chain id for those.

> BTW, where should I sent patches to due to net-next closed?
>

You can keep sending patches just as you did. There's nothing wrong
with doing that as long as you're only doing it for the feedback (RFC
=3D=3D Request For Comments).
Since David receives a lot of patches and the backlog builds up very
quickly, he just rejects patches sent to net-next during the merge
window instead of queuing them up.
Patches that are bugfixes (not the case here, just in general) can be
sent to the net tree at all times (even during the merge window).
In all cases, the mailing list is the same, just the --subject-prefix
is different (net, net-next, rfc).

> Thanks,
> Xiaoliang Yang

Thanks,
-Vladimir
