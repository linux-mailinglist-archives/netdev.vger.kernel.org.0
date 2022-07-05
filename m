Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01458567002
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 15:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbiGENyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 09:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbiGENyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 09:54:06 -0400
X-Greylist: delayed 359 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Jul 2022 06:32:09 PDT
Received: from smtp-8fa8.mail.infomaniak.ch (smtp-8fa8.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fa8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639065590
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 06:32:08 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Lck2j0203zMqKGy;
        Tue,  5 Jul 2022 15:26:05 +0200 (CEST)
Received: from [127.0.0.1] (unknown [10.92.211.175])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4Lck2h4l19zlqV06;
        Tue,  5 Jul 2022 15:26:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1657027564;
        bh=X04nMg7KIWXVr55GSJJdNdLM5zG9bs44VM58INpK+SU=;
        h=Date:Subject:From:Reply-To:To:Cc:References:In-Reply-To:From;
        b=sbEQ8k/9EoRJyW8aFsOgJLn4sTot0TMcNScGdgt5ZAF8L8sRbyTmvYhYfP4DHCt41
         SKMa2cZF2i7HfFCFbcUzpAVpaCk5HyGtE6zCOCA509NglQLyYOXu+RQjV/Oc2xGy4h
         D1eQkG4zZHcYUixo/Aln4G/BgWEwXYVdrGCqN2dU=
Message-ID: <99f4ac6eb9ede955af7426f3989e57a4@mail.infomaniak.com>
Date:   Tue, 05 Jul 2022 15:26:04 +0200
Subject: Re: [PATCH v6 01/17] landlock: renames access mask
From:   =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Reply-To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-WS-User-Origin: eyJpdiI6IjZEVXcxY01rNGhWNzdhV3Vjb3V6UEE9PSIsInZhbHVlIjoiSjExSm0zOG00bXpMbUNiZ1FsNHRtQT09IiwibWFjIjoiMGU4OTQ4ZjhhYmZkNGY4ODBmNDI4YzgwMzQ2YmJjM2FlODEyZTkxODYwY2IyM2JkYjQ5NjhjMzBiZTU1MTRkYiIsInRhZyI6IiJ9
X-WS-User-Mbox: eyJpdiI6IlNvbDJnejMyVldGNU9scyt5QmNBeHc9PSIsInZhbHVlIjoiaEFkVDNiVUNFQXpSU3pDVUYzUnRqQT09IiwibWFjIjoiNGRlNjA4NjNlNGE2YWM1ZGUyNmExYzk2ZmU3YTAyYjRiYTUyMmM3NDY4NjZlYzE4MjQ2ODU2ZGQ0NDUxM2ZiOSIsInRhZyI6IiJ9
X-WS-Location: eJxzKUpMKykGAAfpAmU-
X-Mailer: Infomaniak Workspace (1.3.335)
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
 <20220621082313.3330667-2-konstantin.meskhidze@huawei.com>
 <09f25976-e1a6-02af-e8ca-6feef0cdebec@digikod.net>
 <a211ec4b-9004-2503-d419-217d18505271@huawei.com>
In-Reply-To: <a211ec4b-9004-2503-d419-217d18505271@huawei.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-07-05T13:29:04.000+02:00, Konstantin Meskhidze (A) <konstantin.mesk=
hidze@huawei.com> wrote:
>  7/1/2022 8:08 PM, Micka=C3=ABl Sala=C3=BCn =D0=BF=D0=B8=D1=88=D0=B5=
=D1=82:
>=20
> >   =20
> >  On 21/06/2022 10:22, Konstantin Meskhidze wrote:
> >=20
> > >    To support network type rules,
> > >  this modification extends and renames
> > >  ruleset's access masks.
> > >  This patch adds filesystem helper functions
> > >  to set and get filesystem mask. Also the
> > >  modification adds a helper structure
> > >  landlock_access_mask to support managing
> > >  multiple access mask.
> >  =20
> >  Please use a text-width of 72 columns for all commit messages. You can
> >  also split them into paragraphs.
> > =20
>     By the way, are you going to review the rest patches?

Yes, of course, I'm busy right now but I'll send more reviews by the end of=
 the week.
