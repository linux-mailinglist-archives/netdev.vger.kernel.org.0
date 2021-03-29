Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B91F34D548
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhC2QkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 12:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbhC2Qjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 12:39:49 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461CAC061756
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 09:39:49 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id c17so1339729ybs.0
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 09:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8ggmxZb7lnne8LufmZiqJUJ4OmflVB1olvE1emPiNj8=;
        b=lRXc4mS4kN1vhK9bcARPdF77Fymzf5hfUrxU7RGKPJy8Hr/JVw7R1yb6sdmwsNWISb
         hpfHQOLSUhWu7Ivuh2onLvZ58McwGm2ipzwqLJBTYwpkFvuvLkMatUIY8lrhGQ255rrA
         lmA2P9dPsbgjiqVml/auN5E3xqUr1ny6A7v7xkifAHDE5quDGLuDblxqQM/YRW0NpWaX
         sEUuYWIf82EyBQulH+Pyv/dsO/EAZOgMnO4cuxV1TMjucxNGwDocHmVRyryE6QXvykJD
         CO3R/WBe8LgwG2MvNIStqYdHzt4ApVCNis8TxT3CzVdUU02TW2mZSZsL0XamWB3QEDWz
         9VBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8ggmxZb7lnne8LufmZiqJUJ4OmflVB1olvE1emPiNj8=;
        b=Nb4YETXV0Q5nPkZbQcG7ibx+8/ejCt+TOqKGhQ6YYTArk4Owon5mBhiShxQMaKKiT4
         3GbX83pYXqGfL4aVsYCtjj0eSTuLyeoCgmoItwMEPuEu2qmqm0m8pzGvN81Cocq/JFop
         MfWLcBztgLGZtpnhWJeTXd98S9ORs0yYVTZ+uLV8rekFmwjBHUVmP+vs+rw2gROV6mlv
         Xc2jY/5EFWZHDT47UzE711Lq8Eh0VKMmBiDuZTPYv+WndyXS2412d1pNY8pvTEexVEqv
         X39hXevul3iPijV2P4N03yeHbRCoFAh2SG2DK8vpPLkKY2ZTVNMO22nJJ0S/+XF/03gf
         rO6Q==
X-Gm-Message-State: AOAM533plh2RoJluQhV5LSqGYcOikLQIOsWKImutuCS9htBz1OXILQ8V
        aGW0aIv1IqwPmLkua3hXxQyAvZiDz/x3Zd80fyyWWIKzy9DCWv7KdntSKPnAYc/jxp94qlR/ROY
        +0AzP4xuLmQ71ynmFmJPOSaloZgr5TiTpKcNksURG05DZlbIC2K+ZMA==
X-Google-Smtp-Source: ABdhPJwwXLIwIZp20FRDoeyyu4GL72dKho2qVRx1W3QpRo75b4KIhn2npUB+lJxW75c1y43RBls73VU=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:ede7:5698:2814:57c])
 (user=sdf job=sendgmr) by 2002:a25:4f03:: with SMTP id d3mr37391057ybb.19.1617035988274;
 Mon, 29 Mar 2021 09:39:48 -0700 (PDT)
Date:   Mon, 29 Mar 2021 09:39:46 -0700
In-Reply-To: <20210329162416.2712509-1-sdf@google.com>
Message-Id: <YGIC0u8i8ioy1Uvm@google.com>
Mime-Version: 1.0
References: <20210329162416.2712509-1-sdf@google.com>
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: Fix warnings
From:   sdf@google.com
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/29, Stanislav Fomichev wrote:
> * make eprintf static, used only in main.c
> * initialize ret in eprintf
> * remove unused *tmp

> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   tools/bpf/resolve_btfids/main.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

> diff --git a/tools/bpf/resolve_btfids/main.c  
> b/tools/bpf/resolve_btfids/main.c
> index 80d966cfcaa1..a650422f7430 100644
> --- a/tools/bpf/resolve_btfids/main.c
> +++ b/tools/bpf/resolve_btfids/main.c
> @@ -115,10 +115,10 @@ struct object {

>   static int verbose;

> -int eprintf(int level, int var, const char *fmt, ...)
> +static int eprintf(int level, int var, const char *fmt, ...)
>   {
>   	va_list args;
> -	int ret;
> +	int ret = 0;

>   	if (var >= level) {
>   		va_start(args, fmt);
> @@ -403,7 +403,7 @@ static int symbols_collect(struct object *obj)
>   	 * __BTF_ID__* over .BTF_ids section.
>   	 */
>   	for (i = 0; !err && i < n; i++) {
> -		char *tmp, *prefix;
> +		char *prefix;
>   		struct btf_id *id;
>   		GElf_Sym sym;
>   		int err = -1;
> --
> 2.31.0.291.g576ba9dcdaf-goog


Looks like that 'int err = -1' is also unused.
I'll respin, please ignore this one. Sorry for the noise.
