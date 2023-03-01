Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670C06A76C2
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 23:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjCAWWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 17:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCAWWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 17:22:43 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9491B2C0
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 14:22:42 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id r4so9336919ila.2
        for <netdev@vger.kernel.org>; Wed, 01 Mar 2023 14:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677709362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1OfUsPNZa/yCh5ZP0Yea9ZJmv1L6xq50Y+PGxW2aZI=;
        b=KRQ158g7VMbGrxbxsKzDdVlLzBYl7VW2zDWcjPlzShif5Prvf/pP/sOyyOASEzahJi
         wQf8AgOXqRvjwLkvBtWyu8p+DiR3ebxF3amr//bHPp7+5a3Z23k1IA5hxkCsVJxkxEUD
         DHO2vzws2U/XO9NjzZAbw76RErI95+mvc84zd4Qiq8LiboFikrHcreW9Dcw9if35nezH
         StEvY7Q+hR4/ib4Uev2AD4PgCEU+8MpLaYlvAlyqm6N+JennhjJLzeA8qEDMmVMP1Fud
         sbljIZD1g8PgZNGaNmQfGKS0t7Ura0ZRUpNpCFHVr1eKCQAkeJccKNu6G9+JNxrImeLx
         okmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677709362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k1OfUsPNZa/yCh5ZP0Yea9ZJmv1L6xq50Y+PGxW2aZI=;
        b=rOlexyQUKJ2VdgXXf5I3WdLlpH2wbAjs3QXbKefD5oMBJ2yOHY9pGEYv6fTHisKjd3
         o/hUQ7vmAusPhgxzQoKydMbFvk8RvxTstj1WTU8GFHBRA95waylgdd76FNjanM7pbPYz
         JTVn0xa1DH/S2uenPFxyPh7GNG5cHNaq1onEQgQfPSvQD5feOF9h/tE2RGurmsE8wB35
         jV6BGgsVHo3smwnZHcbPNieHI8wmLk+yoqPgf0okGZWPrczapb1EPRojfbR2O1PAV4Oj
         ay/dhQt2vPDpqk5p6n4B7LB6zR75OcGT7AQez4fy5eWEvl3FuXmkQIiDjiMFHfHp1eMc
         xpww==
X-Gm-Message-State: AO0yUKU5xNgjEEanu40b1XekbeM03soguFxV1g0MFUKGGPioiGsHmSEV
        bDn3TgUO6DH5eyq+tQLjigo3xyEg+o6y08u55n10Gg==
X-Google-Smtp-Source: AK7set9sbtGGP/xTmOF61RUzH+wJKaLJIf/y6gD4BErAlzjMcup7DHHzWbe38lQjD/8oneX+9jdsGYSWcRcus2LsP50=
X-Received: by 2002:a92:1a0d:0:b0:310:a24c:4231 with SMTP id
 a13-20020a921a0d000000b00310a24c4231mr3867674ila.6.1677709362077; Wed, 01 Mar
 2023 14:22:42 -0800 (PST)
MIME-Version: 1.0
References: <20230301211146.1974507-1-willemdebruijn.kernel@gmail.com> <7d4571c6-b708-c63b-5a5c-2b2d4f963914@gmail.com>
In-Reply-To: <7d4571c6-b708-c63b-5a5c-2b2d4f963914@gmail.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Wed, 1 Mar 2023 17:22:05 -0500
Message-ID: <CA+FuTSd2=8e73ALPxZR8k03oHOrsJfAQwoaLT+i-YLzwwCf+Bg@mail.gmail.com>
Subject: Re: [PATCH manpages 1/2] udp.7: add UDP_SEGMENT
To:     Alejandro Colomar <alx.manpages@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-man@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 1, 2023 at 4:35=E2=80=AFPM Alejandro Colomar <alx.manpages@gmai=
l.com> wrote:
>
> Hi Willem,
>
> On 3/1/23 22:11, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > UDP_SEGMENT was added in commit bec1f6f69736
> > ("udp: generate gso with UDP_SEGMENT")
> >
> >     $ git describe --contains bec1f6f69736
> >     linux/v4.18-rc1~114^2~377^2~8
> >
> > Kernel source has example code in tools/testing/selftests/net/udpgso*
> >
> > Per https://www.kernel.org/doc/man-pages/patches.html,
> > "Describe how you obtained the information in your patch":
> > I am the author of the above commit and follow-ons.
> >
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > ---
> >  man7/udp.7 | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> >
> > diff --git a/man7/udp.7 b/man7/udp.7
> > index 5822bc551fdf..ec16306df605 100644
> > --- a/man7/udp.7
> > +++ b/man7/udp.7
> > @@ -204,6 +204,31 @@ portable.
> >  .\"     UDP_ENCAP_ESPINUDP draft-ietf-ipsec-udp-encaps-06
> >  .\"     UDP_ENCAP_L2TPINUDP rfc2661
> >  .\" FIXME Document UDP_NO_CHECK6_TX and UDP_NO_CHECK6_RX, added in Lin=
ux 3.16
> > +.TP
> > +.BR UDP_SEGMENT " (since Linux 4.18)"
> > +Enables UDP segmentation offload.
> > +Segmentation offload reduces
> > +.BR send(2)
> > +cost by transferring multiple datagrams worth of data as a single
> > +large packet through the kernel transmit path, even when that
>
> Please use semantic newlines.  See man-pages(7):
>
>    Use semantic newlines
>        In the source of a manual page, new sentences should be started
>        on  new  lines,  long  sentences  should be split into lines at
>        clause breaks (commas, semicolons, colons, and so on), and long
>        clauses should be split at phrase boundaries.  This convention,
>        sometimes known as "semantic newlines", makes it easier to  see
>        the  effect of patches, which often operate at the level of in=E2=
=80=90
>        dividual sentences, clauses, or phrases.
>
>
> > +exceeds MTU.
> > +As late as possible, the large packet is split by segment size into a
> > +series of datagrams.
> > +This segmentation offload step is deferred to hardware if supported,
> > +else performed in software.
> > +This option takes a value between 0 and USHRT_MAX that sets the
> > +segment size: the size of datagram payload, excluding the UDP header.
> > +The segment size must be chosen such that at most 64 datagrams are
> > +sent in a single call and that the datagrams after segmentation meet
> > +the same MTU rules that apply to datagrams sent without this option.
> > +Segmentation offload depends on checksum offload, as datagram
> > +checksums are computed after segmentation.
> > +The option may also be set for individual
> > +.BR sendmsg(2)
>
> There should be a space between the bold part and the roman part:
>
> .BR foo (2)
>
> Otherwise, it all gets printed in bold.

Thanks Alex. I'll leave this open for other comments for a bit, but
will address both points in both patches in v2.
