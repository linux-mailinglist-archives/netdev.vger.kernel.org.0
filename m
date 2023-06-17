Return-Path: <netdev+bounces-11707-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BBA5E733FA4
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 10:29:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FEDA281858
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 814E3748B;
	Sat, 17 Jun 2023 08:29:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D6B1C33
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 08:29:20 +0000 (UTC)
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6221FF7
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 01:29:18 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-25edb50c3acso134719a91.1
        for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 01:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686990558; x=1689582558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T7zvLgMQNOS4thpxSt/o4jTmAbW5w4N+SoOGdd1Z5+E=;
        b=Kzxtz/1qDN+woQNvk4cGrBYylJxttSzye0eofPxIovlfr9xRFv/6g0FBH2nIfN83F1
         j+VNqIBbuCrq4YnSYk+NfKGo73BaQQfDYl5fNgdV5mEJ4BTUZnq0OW0omWni6kyiv0pn
         qP6YNZ0V5WnoZ1lx0m1dq9vtk5BRmfEr6GnqZq98jWyN50QBc2buw/wWJozDihQag9se
         CR0cvX56sE1vLWr5DhVYsMcF/GDnkMEwBYYyYOsPHV4epL6sjfOXzpKOodk3PcdKPqQ+
         OJH6O4yW4aFq6tt6A15KBleQfYXGSNDV7PpeJlqj5reIw0GKWT6PQ0EoOj2nlfXTRJm3
         E/fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686990558; x=1689582558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T7zvLgMQNOS4thpxSt/o4jTmAbW5w4N+SoOGdd1Z5+E=;
        b=ltvEYdWT79c0Pmow2q9jR0/JieZjlUdelDCdSu91n14AwZ2SUVTrjYsI5EgzFPUpck
         4XDI9PFGbn7tK+pLlhLiCRVVqdI4uMuwM92SRZJZUrUfmx9glDtD3K/ytuizY/2tApxB
         Z5VvvCK0Nx4D5oscyhSJGSB4f9vwQR7zGnyy42v5Aah+lliR2Z+hwe5oP2TcVNjbMV9J
         swNiiyHvyTEuuKFK/30AVE3JlqQ8F+zw/lAUG3IuS+iv1OOqQcLvHzjIbK91TJmjxl5f
         MWXsPSeO+OuiBcu0J5d5pJHTAOGfrO2On4OsodU/B5x8cX9QKgMMRjys+rQ75dKInM+W
         ttrQ==
X-Gm-Message-State: AC+VfDxD0/SfDeorJQnRxRf2v+B10Lnxo80V8N0Cz87PBjifW5EVIqeH
	Apgmd4iSp/y8y3H8Xms/yIMfzZrlCcTvx/ZaPWJM+u3c/jQRNw==
X-Google-Smtp-Source: ACHHUZ7lPdUSX4Fvgmp5GiZrMpLn0fsUc3H2cRCc/oz6F/2gcbsKfPxURltL0GOiCfIH7w58izSa4iuTlnvJ98C0zCQ=
X-Received: by 2002:a17:90a:8a0b:b0:256:2cb7:406e with SMTP id
 w11-20020a17090a8a0b00b002562cb7406emr4311582pjn.45.1686990558318; Sat, 17
 Jun 2023 01:29:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZHmjlzbRi0nHUuTU@Laptop-X1> <ZIFOY02zi9FZ+aNh@Laptop-X1> <1816.1686966353@famine>
In-Reply-To: <1816.1686966353@famine>
From: Hangbin Liu <liuhangbin@gmail.com>
Date: Sat, 17 Jun 2023 16:29:06 +0800
Message-ID: <CAPwn2JRuU0+XEOnsETjrOpRi4YYXT+BemsaH1K5cAOnP4G-Wvw@mail.gmail.com>
Subject: Re: [Discuss] IPv4 packets lost with macvlan over bond alb
To: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 17, 2023 at 9:45=E2=80=AFAM Jay Vosburgh <jay.vosburgh@canonica=
l.com> wrote:
>
> Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> >Hi Jay, any thoughts?
>
>         Just an update that I've done some poking with your reproducer;
> as described, the ARP reply for the IP address associated with the
> macvlan interface is coming back with the bond's MAC, not the MAC of the
> macvlan.  If I manually create a neighbour entry on the client with the
> corrent IP and MAC for the macvlan, then connectivity works as expected.
>
>         I'll have to look a bit further into the ARP MAC selection logic
> here (i.e., where does that MAC come from when the ARP reply is
> generated).  It also makes me wonder what's special about macvlan, e.g.,
> why doesn't regular VLAN (or other stacked devices) fail in the same way
> (or maybe it does and nobody has noticed).

VLAN or other overlay devices use the same MAC address with Bonding.
So they work with the alb mode. But MACVLAN uses different MAC
addresses with Bonding.

Thanks
Hangbin

