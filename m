Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB533681AA0
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238075AbjA3Tg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238161AbjA3Tg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:36:26 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DF240BFF
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:36:25 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id o11-20020a17090aac0b00b0022c579ce0f0so3132429pjq.1
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vggk284JPOE/rhy5SXyFKsj7j76TcRS65xvoJRP0zNU=;
        b=GcvS5ib0x5LRZZr/K1+gPEdqcWnbCKkyPynCIAZ9m/jMhWTPvIflOD7K0gZgl3IPMA
         m9EZOFfcXHgEFFGnUYQ6rCn25srMKIhiGGGwoPntGMtkUSE8AL494WcQMA7oauY85Gbn
         0eyMGlTAALbUClTDltAwpOH+c7ycG1pWJZ7YaK4jfR8HDoT5Rai/2YuFIlBML6n/OAYE
         Q2qSFj0qQLibhAt1crdAR4lz0cLTnL5TA8umYIDkHq8Nx3BUIGP1nV1Hp8ng+93C+uOt
         x8A7lTx3/GIWEUn8N42IfiaUIc8sFy8hI5LIXynCaViSdStd0GB3UXtVspV8ePYXGFNu
         3/NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vggk284JPOE/rhy5SXyFKsj7j76TcRS65xvoJRP0zNU=;
        b=rEuoZe/qMvmTT648NiJQ4XtLMwLND9DtdRB0/Uvin6MW//0GXhU86nvTZgVnyNHLy1
         PMjbQhNIZskruSZeoXJB3ct4nAwkPLRQ1N0T6+sfHmlOXSiv6aLuBQ+iaS/y9fj/sQV9
         R0icYi5C0tRvt3c81a5TgBUTlLDSDof0m8NbPcsbO/twjFGGMiZ1OknD7kpIFeFUb5h5
         dZDA5T6yFwV0y9KZCSBCBpB17FziUyyb8SheXU3loW7DU+E10yWO4PM833h/55WxCiMO
         XglpJTW/OYiOkK7wYd7GM0H7vYh8z9+8zzhFicm05fjjEdy7hUXBsU8sE9gEuErGN5CZ
         CrzQ==
X-Gm-Message-State: AFqh2krFmzU6zzW6TswhsH6CYHnN2umQjvw5fw5O7iRStHLDtBdK3LsO
        P6cD43iY69gIRjCc8r71pFZQgX4=
X-Google-Smtp-Source: AMrXdXt/PWctlW/9kcQFSEjmeikVILIpEM/91Z5rdxXFzQzHGkVsaSCck0vgW13sQAmvKhiJPJxVYWY=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:aa0c:b0:229:f43b:507c with SMTP id
 k12-20020a17090aaa0c00b00229f43b507cmr5584228pjq.127.1675107384687; Mon, 30
 Jan 2023 11:36:24 -0800 (PST)
Date:   Mon, 30 Jan 2023 11:36:23 -0800
In-Reply-To: <20230128043217.1572362-1-kuba@kernel.org>
Mime-Version: 1.0
References: <20230128043217.1572362-1-kuba@kernel.org>
Message-ID: <Y9gcN9agk89c2K3l@google.com>
Subject: Re: [PATCH net-next 00/13] tools: ynl: more docs and basic ethtool support
From:   Stanislav Fomichev <sdf@google.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/27, Jakub Kicinski wrote:
> I got discouraged from supporting ethtool in specs, because
> generating the user space C code seems a little tricky.
> The messages are ID'ed in a "directional" way (to and from
> kernel are separate ID "spaces"). There is value, however,
> in having the spec and being able to for example use it
> in Python.

> After paying off some technical debt - add a partial
> ethtool spec. Partial because the header for ethtool is almost
> a 1000 LoC, so converting in one sitting is tough. But adding
> new commands should be trivial now.

> Last but not least I add more docs, I realized that I've been
> sending a similar "instructions" email to people working on
> new families. It's now intro-specs.rst.

FWIW, I've played with it a bit and left some nits in the doc:

Acked-by: Stanislav Fomichev <sdf@google.com>

One unrelated thing that maybe worth mentioning is that /usr/bin/python
is no more on Debian and there is only /usr/bin/python3, so maybe worth
changing the /usr/bin/env shebang to python3? (although I'm not sure
what's the story overall with 2->3 migration; archlinux has a  
python->python3
symlink).

> Jakub Kicinski (13):
>    tools: ynl-gen: prevent do / dump reordering
>    tools: ynl: move the cli and netlink code around
>    tools: ynl: add an object hierarchy to represent parsed spec
>    tools: ynl: use the common YAML loading and validation code
>    tools: ynl: add support for types needed by ethtool
>    tools: ynl: support directional enum-model in CLI
>    tools: ynl: support multi-attr
>    tools: ynl: support pretty printing bad attribute names
>    tools: ynl: use operation names from spec on the CLI
>    tools: ynl: load jsonschema on demand
>    netlink: specs: finish up operation enum-models
>    netlink: specs: add partial specification for ethtool
>    docs: netlink: add a starting guide for working with specs

>   Documentation/netlink/genetlink-c.yaml        |   4 +-
>   Documentation/netlink/genetlink-legacy.yaml   |  11 +-
>   Documentation/netlink/genetlink.yaml          |   4 +-
>   Documentation/netlink/specs/ethtool.yaml      | 392 ++++++++++++++++++
>   .../netlink/genetlink-legacy.rst              |  82 ++++
>   Documentation/userspace-api/netlink/index.rst |   1 +
>   .../userspace-api/netlink/intro-specs.rst     |  80 ++++
>   Documentation/userspace-api/netlink/specs.rst |   3 +
>   tools/net/ynl/{samples => }/cli.py            |  15 +-
>   tools/net/ynl/lib/__init__.py                 |   7 +
>   tools/net/ynl/lib/nlspec.py                   | 310 ++++++++++++++
>   tools/net/ynl/{samples => lib}/ynl.py         | 192 +++++----
>   tools/net/ynl/ynl-gen-c.py                    | 260 ++++++------
>   13 files changed, 1107 insertions(+), 254 deletions(-)
>   create mode 100644 Documentation/netlink/specs/ethtool.yaml
>   create mode 100644 Documentation/userspace-api/netlink/intro-specs.rst
>   rename tools/net/ynl/{samples => }/cli.py (78%)
>   create mode 100644 tools/net/ynl/lib/__init__.py
>   create mode 100644 tools/net/ynl/lib/nlspec.py
>   rename tools/net/ynl/{samples => lib}/ynl.py (79%)

> --
> 2.39.1

