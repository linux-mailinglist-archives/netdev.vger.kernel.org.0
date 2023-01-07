Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E28660EB0
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 13:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbjAGMYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 07:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjAGMYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 07:24:31 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B20360CE8;
        Sat,  7 Jan 2023 04:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1673094231;
        bh=zv9DFz2jFU7cwgarhZpClLtUvJqk7GOMCDtGW4naVT4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=hbAOPRtSb4588GuGdrreMXwPNKZzA8qLj0qIC6pxdDTQB8M+r5wxb8kCPYrrf/0UW
         x+BOek4gnxBmzNEdiZ170bcM+j41CLvtvGVJtzLYRKeOAbW+tLCpZva0Rsqg4+qzdL
         +ovfeXt0aToUj+rRFcBqMuTcmMnMrPEN1qncGGIbm8pOURdl4tZ4e8oZfaFPOVXAqu
         0HoqcyUZ0bZjICnAPO303ej8Tia+MRrdNe4TDk1v99ca6OewdpAq4MCuFZSA1BdSD7
         ++yHyddhAX4MiCbTPijTZ21oNhmfX+rCPZ7tc+63wKu5ha5zllyMwX4AMsT4lnXi3g
         77phW1xspdWLw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.149.37] ([217.61.149.37]) by web-mail.gmx.net
 (3c-app-gmx-bap38.server.lan [172.19.172.108]) (via HTTP); Sat, 7 Jan 2023
 13:23:50 +0100
MIME-Version: 1.0
Message-ID: <trinity-88ad03e9-e830-4898-93f0-106af8b753bd-1673094230865@3c-app-gmx-bap38>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Aw: Re:  Re: Re: [PATCH net v3 4/5] net: ethernet: mtk_eth_soc:
 drop generic vlan rx offload, only use DSA untagging
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 7 Jan 2023 13:23:50 +0100
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:wP4TMKG2DaLks5PJfrg2GiHqrg61/W8XG98+sNB3yE8BNT7gs3jeY2pXQVQKnB7KxWyUS
 K5gRCfuJyh+1XkzUHJYtYdCyz12l1Zrq2nJXf2uy7GIx4Q+0TfZ86VV7pbS+KPUjhTZu3RMng/up
 gr67XmEPFWRWirGMyy0KXX0dDCBELBUm7bo1YDH/eomd69m06ar2+5LgUiPk0bRdVWPlIGFV2yCX
 3WwyLlARITSboIzUqWrkF0qDjrmaOJrdwkB9XVL61jT7xuBZdAgg4eSrrYmhGW+coaew3xGIpP9K
 Gc=
UI-OutboundReport: notjunk:1;M01:P0:UIrRf/JzP+0=;92GAdljAG5pcOdjgtJXbJhVbr1z
 MYRfKTlAMm+8VBnPWol1WaUFOO1zKpSY0/vTXsjeXWhxiWax0Zc5vbK7M2Fq4EXosoZHKfVjf
 1A/n7THFpjvoALbpfzC4WZU/2vHhXNeHCbLDy3NtWq85bgwvidRz4P9tDUTrNvRB9YgAlvYbQ
 b58NB5HVVLMqwS/Fxhp29FtMG3cvehpBLxN0lVf+1dcldosd0CoW3zRvSOC2ctkfY4VlfoMFp
 7k1fVyVfar+ZSC+HKnXeuLEZF2QHYQSmOQMQXAEpOiXfaqaq+wBWsIZFfnc/iEyELv7WbTurm
 ijROU15BsZDdARYwMbWm4X6ZmLE6/UnXIxvN6hoBMb7ycKSRQbOAvAml5Ql0hv3ir2IOK56Ms
 n9+t32zdTlMfu1NaXEPsaqKR7QSI+bWGRAfp/iDjg9YOQjISAQ1zeR9CuZtPnGF1Qp+F6lUWx
 3i2vNr8XzOMM71xklgjniMh74y4ze56L+f9l4cs0+5Mn1EmKjQt5Tes7c91j3qnvPTSYO2gwC
 FXKp6eBexPneP/Bq/6d6iwQHslBfprX5KcGo9qD43mbOTTOrYnN1eA1vKouXjzQp+Q42cu2gr
 Seykp6axgvDcl5BSp2ox2hBzcUA64d6Bt/ak391zvTvHDK02U7wjJIE1TrzQzE0dKJFjOSajK
 T2Vq110SDrT3xQTIiKvHDAsaunF+wB5eyQmHbGD/S/TAsHn343zPDTSB/YuBE9ajoVpAktw2U
 7g6pBEpje75bGYB6xnF38GpTayoo7CGOZRgE6My4CfWg4YpGcdqRW8B84OCdOI17PVQXrkXxn
 13v2RlCe0Gs/pw4G9T9Cnu+Zj3lCekIcISIecUcklGlUI=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

FYI, opened a systemd issue on github

https://github.com/systemd/systemd/issues/25970

---

regards Frank

Hi,

update on my tests...something in my systemd-networkd breaks vlan on dsa-port.

if i boot with this disabled vlan added manually works on dsa-port and gmac too. so felix you can keep my tested-by.

if vlan is working and i activate networkd afterwards vlans are still working...i guess systemd puts the wan-interface into some kind of non-vlan-mode (vlan-filtering?).

...
