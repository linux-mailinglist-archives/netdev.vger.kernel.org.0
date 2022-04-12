Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB19F4FDFD7
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351893AbiDLMaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353230AbiDLM1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:27:55 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA79FA;
        Tue, 12 Apr 2022 04:37:20 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id lc2so16159195ejb.12;
        Tue, 12 Apr 2022 04:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Ireb+u2fz+HNDp7W/0u9tq1dE6EEB8pXAEENxA5hKe0=;
        b=N3/DiKCNwWEXj6baA/2A7S/u+N9x0cmIYnpFq5u882hKTkppGapWKjCAzu6HvUzdTb
         sYHXpr6qZJwnrsqJWLdgMv0sg/7fxY1FO0iUCbgAS/aWCtA+qdSsgSjdtQ3Vl3kikFaH
         Ity+WWj1mcX+25gbyeHsj2h2Yom8e5qNmDrIgfpEJ0jbVf13S1FtMLyYY+CamfhXm4Hh
         kByIIuYOH90KylSxKVeYQ7BkbiYp8IvlnQyKLDAbYLYocFfUF8J226MVMo374edYU8Wi
         iUcGMPq5CQsOFI0pyC/0IOSBJpjRAvS2afx8ubJTpSig8FABBB3LfG2S4Ep5WP5xXqft
         F3Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Ireb+u2fz+HNDp7W/0u9tq1dE6EEB8pXAEENxA5hKe0=;
        b=D0KMMDv721CqO0pRdzvq1kUkQu+OQsixGEM/4WalE8RmwAzNGk+g2BbclxN9+i+V+9
         RryVJ7PtCNBC9oVjzWxvFh7jruFumzeUTryQkMiL7PxEAlui7bLRJGHsswUfquXqUGwu
         7k0LqasSrfTazscANSJsA8RuOwWv003Kfgo5hHJtU1FF56i/BMIQBul1iQE2/sUt+CGI
         3pQ7gxD6Pp/6yGJg3jUbuFFvgk9PWrDoZA+oaFFONMacTU/g4BFphe0T3glDWNh6GOBR
         A7NtrVfaMZLml5Htb5LbiPLHsxw0dov5iNwYyDkcAEdpzHk0DSDtbGmVLf7hsn1cRQCf
         1xfQ==
X-Gm-Message-State: AOAM532ghH5Y2AgEEsy2W/HO4dGzvjdTWyVsfle7zLxsF3avG+YXbfog
        J/rMDofXfl4e7VdGsZu79cQ=
X-Google-Smtp-Source: ABdhPJyVdngo1HvueM2ZUMpF2ABzA9tTU6Hq/Z1IehvEZwx5+grwH5M0xobTdptT/tEuHm5m8cBuXw==
X-Received: by 2002:a17:907:160b:b0:6e8:58c1:8850 with SMTP id hb11-20020a170907160b00b006e858c18850mr14414194ejc.284.1649763438997;
        Tue, 12 Apr 2022 04:37:18 -0700 (PDT)
Received: from smtpclient.apple (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.gmail.com with ESMTPSA id fu13-20020a170907b00d00b006e8ae97f91asm947697ejc.64.2022.04.12.04.37.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Apr 2022 04:37:18 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH net-next v2 05/18] net: dsa: mv88e6xxx: remove redundant
 check in mv88e6xxx_port_vlan()
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <YlViPWWKhvoV2DLN@shell.armlinux.org.uk>
Date:   Tue, 12 Apr 2022 13:37:17 +0200
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8BAFAAD1-D9AB-4339-BE81-18BE564F78F6@gmail.com>
References: <20220412105830.3495846-1-jakobkoschel@gmail.com>
 <20220412105830.3495846-6-jakobkoschel@gmail.com>
 <YlViPWWKhvoV2DLN@shell.armlinux.org.uk>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 12. Apr 2022, at 13:27, Russell King (Oracle) =
<linux@armlinux.org.uk> wrote:
>=20
> On Tue, Apr 12, 2022 at 12:58:17PM +0200, Jakob Koschel wrote:
>> We know that "dev > dst->last_switch" in the "else" block.
>> In other words, that "dev - dst->last_switch" is > 0.
>>=20
>> dsa_port_bridge_num_get(dp) can be 0, but the check
>> "if (bridge_num + dst->last_switch !=3D dev) continue", rewritten as
>> "if (bridge_num !=3D dev - dst->last_switch) continue", aka
>> "if (bridge_num !=3D something which cannot be 0) continue",
>> makes it redundant to have the extra "if (!bridge_num) continue" =
logic,
>> since a bridge_num of zero would have been skipped anyway.
>>=20
>> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> Isn't this Vladimir's patch?
>=20
> If so, it should be commited as Vladimir as the author, and Vladimir's
> sign-off should appear before yours. When sending out such patches,
> there should be a From: line for Vladimir as the first line in the =
body
> of the patch email.

yes, you are right. I wasn't sure on how to send those commits, but
I guess if I just set the commit author correctly it should be fine.

regarding the order: I thought I did it correctly doing bottom up but
I confused the order, wasn't on purpose. Sorry about that.

I'll resend after verifying all the authors and sign-offs are correct.

>=20
> The same goes for the next mv88e6xxx patch in this series - I think
> both of these are the patches Vladimir sent in his email:
>=20
> https://lore.kernel.org/r/20220408123101.p33jpynhqo67hebe@skbuf
>=20
> Thanks.
>=20
> --=20
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Thanks for pointing it out!
Jakob

