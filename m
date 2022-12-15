Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA1664D608
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 06:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiLOFLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 00:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLOFLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 00:11:42 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C762A409
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 21:11:39 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id a16so25524674edb.9
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 21:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a4GJPfUPphC/NnaxgI4s5VdeB2tjK0JZpDnkjcz6Ynk=;
        b=e73vwErmj4//ONORMhlkj+LcOxQ6urzVnYx/OVKXUQhtFQmWX9Pt8mxml2ySB0dITE
         d+sws0m3AW9/optr6dIfvBsZiqSn2LBpk4lQjBDrQ/mh3qoXTD5Q+yDM9P9xwzWqGFht
         ZIKeVV7KNkX1LTP2O8luPlsyElFHee4vifBSjkXzeFKkFoI+51GBWug4exFfD2YKbZbJ
         GutJcrSZb0wFajYFBCYdYRhLn0HKUNNbGMbFXGOhfKWCsy6ii5WvBRVDUyDo/ew+wUs0
         Gw4+klHsAhTBpBGbe7JAmRJFa8eaSYQJvu7So0S1aq0XdyupJjiKPgq9eTvFSnKHDRLX
         VZ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a4GJPfUPphC/NnaxgI4s5VdeB2tjK0JZpDnkjcz6Ynk=;
        b=gXIj6Ovwb5nGRDrkbksgbfcOvaqDohwYEyWiXVB5q13R6xcCYPrgXXOqu47enq/4IA
         KH5juPTu3YDD3KnLuUk94JPe7TOLoZRyz53F5mO9onyW+Ic3NzsGs8YzD7pwElDpim6g
         cKfr7+OOaaAl7pzNZKGdiaQBpNQdSlbfgPJ15xaqlLNocyqvsV/V1hDh5WcL7bFCdNLR
         IAB5Z18QxiMsIAYX4UdaBXHV+EaV6xqOkKLcjRiqdWQMTd7DP8y6uswJ4snn9YFrfuG0
         W3c96YF5a2Yr7eGRqpkk3NWa7RIQh7Qg9EOzeAqFVleyeNZNTOxARlvP9ozpVaQpNrXZ
         De1A==
X-Gm-Message-State: ANoB5plLz4TU5EEBGgWisnUKKhtiEgD8IOFbD5GkkV3pyUgLnxKtJYEa
        qPfqnkRdc56prvDgxuJJVbUDs3JJ+kSGAi2XPVDTdKmoHYV2YA==
X-Google-Smtp-Source: AA0mqf48YLjXYFeN9CkKHPwpyK93rtPWGYo1ORe9HVfeUxb3YrXTtyCCPK3V3uADZ35sQbvn0VqbNAeLm7gJgOK6AN8=
X-Received: by 2002:a05:6402:5308:b0:460:19c3:2992 with SMTP id
 eo8-20020a056402530800b0046019c32992mr12310464edb.1.1671081097788; Wed, 14
 Dec 2022 21:11:37 -0800 (PST)
MIME-Version: 1.0
References: <20221215035651.65759-1-glipus@gmail.com> <20221214202213.36ab31c0@kernel.org>
In-Reply-To: <20221214202213.36ab31c0@kernel.org>
From:   Max Georgiev <glipus@gmail.com>
Date:   Wed, 14 Dec 2022 22:11:26 -0700
Message-ID: <CAP5jrPH=1rhTCmNNgr3XZ5-qfixhY7Laz_qJ-N7rVUhVuOd4DA@mail.gmail.com>
Subject: Re: [PATCH ethtool-next v2 v2] JSON output support for Netlink
 implementation of --show-coalesce option
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 9:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 14 Dec 2022 20:56:51 -0700 Maxim Georgiev wrote:
> > Add --json support for Netlink implementation of --show-coalesce option
> > No changes for non-JSON output for this featire.
>
> s/featire/feature/
>
> I'd add another sentence here, something like:
>
>  Note that all callers of show_u32() have to be updated but only
>  coalesce is converted fully.
>
> To make it clear that the interspersed printf()s don't matter.
>
> One small nit pick below:
>
> > @@ -92,7 +113,12 @@ int nl_gcoalesce(struct cmd_context *ctx)
> >                                     ETHTOOL_A_COALESCE_HEADER, 0);
> >       if (ret < 0)
> >               return ret;
> > -     return nlsock_send_get_request(nlsk, coalesce_reply_cb);
> > +
> > +     new_json_obj(ctx->json);
> > +     ret = nlsock_send_get_request(nlsk, coalesce_reply_cb);
> > +     delete_json_obj();
> > +     return ret;
> > +
> >  }
>
> Empty line befre closing bracket unnecessary.

Thank you for catching it!
I'll submit the updated patch version shortly.
