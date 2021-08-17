Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFC13EF0B5
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 19:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhHQRR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 13:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbhHQRR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 13:17:56 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B59BC061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 10:17:23 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id om1-20020a17090b3a8100b0017941c44ce4so6372071pjb.3
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 10:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=AtjmGLKkUZiB/Diulg++TzoA7nt+VOU4SUjGbG2sSeI=;
        b=DiK9X7BLL7AriAvNqocgG/39iTxfmpHS4JtARXmU0cAPsFATY+k2oprgO17bKzP9e+
         NpEBNYcpRAaFIy4Hx+V2iSaa+6l9W/JWpFPypKgPKXQBryIGDzmOTctB8gAvykEwnN1p
         PDT+MvbVXRke6nr4G9qm5PnVUu7+XTYThSrODGcmAWeBOhq8N2n/sWufFNvx6RzA0SeH
         JE0KIApiiwhToCw6xNjkFY8bnEeopgeu09aPVvrmZfn2LPzHZpMcvyPdXp/vHTbAQ7ee
         1gFNzQDaliLiOjbWhw9ImfRhEKyPJvsQ8n4P9Hm9x7bsLPpg/8xG19dvSBpW30I5M6wP
         zeYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AtjmGLKkUZiB/Diulg++TzoA7nt+VOU4SUjGbG2sSeI=;
        b=ZbxrhfzRGuUUHDLbWEfh9XMswAgVgVjOgWwfcra+sibtoZU47A1Ag+0B/w9U/Ul4Kp
         FNT8QLjEYov4NtJ3cd5iVuErU45e3S9zQi0vzBD3OhDcuXPMGhEuAXtPOOCfwLCv+QRa
         39jITetoQG8+mmANBbFYwgFMhUUzQz+DlxuUd3WEEASIgwnIGuEZ6ewFH25a8lHjcBiu
         9YNLitAjGBp2Ea0tY85txO/7HkGfoAQB5u3YvTgJg80/mr2EaBAYAD02Z7amD35Bi5yQ
         Crr55z1YAWNYQGLVJ+pKCunm3CRlGLi0nh8JdY4OsxShKdMd/MhDqtY5j1GNr1oOk/DA
         eH8A==
X-Gm-Message-State: AOAM532lEIDpfvsm6e956Wmt4wSekcha1hqWgd8nJdev2q983Wqc2gEX
        qXN65HG9MERD7bOaYEM7fWc=
X-Google-Smtp-Source: ABdhPJwIiXGJ/351aNbkXCt4L8AShj8p08M66tL1LrD6MYuyhZXjVh/3AU+iyqbMfzTyKBHdfVXhfA==
X-Received: by 2002:a62:78c1:0:b0:3e2:bdc:6952 with SMTP id t184-20020a6278c1000000b003e20bdc6952mr4586622pfc.45.1629220642847;
        Tue, 17 Aug 2021 10:17:22 -0700 (PDT)
Received: from [192.168.150.112] ([49.206.114.79])
        by smtp.gmail.com with ESMTPSA id c26sm3978477pgl.10.2021.08.17.10.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 10:17:21 -0700 (PDT)
Message-ID: <0a6f29cb5d3240bc880e48a88f1b603e1f081c3a.camel@gmail.com>
Subject: Re: [PATCH iproute2-next v2 1/3] bridge: reorder cmd line arg
 parsing to let "-c" detected as "color" option
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Date:   Tue, 17 Aug 2021 22:47:18 +0530
In-Reply-To: <97b96fce-29a0-b9ab-1049-33d50de912a7@gmail.com>
References: <20210814184727.2405108-1-gokulkumar792@gmail.com>
         <20210814184727.2405108-2-gokulkumar792@gmail.com>
         <97b96fce-29a0-b9ab-1049-33d50de912a7@gmail.com>
Content-Type: text/plain; charset="UTF-7"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-08-17 at 09:11 -0600, David Ahern wrote:
+AD4 On 8/14/21 12:47 PM, Gokul Sivakumar wrote:
+AD4 +AD4 As per the man/man8/bridge.8 page, the shorthand cmd line arg +ACI--c+ACI can be
+AD4 +AD4 used to colorize the bridge cmd output. But while parsing the args in while
+AD4 +AD4 loop, matches() detects +ACI--c+ACI as +ACI--compressedvlans+ACI instead of +ACI--color+ACI, so
+AD4 +AD4 fix this by doing the check for +ACI--color+ACI option first before checking for
+AD4 +AD4 +ACI--compressedvlans+ACI.
+AD4 +AD4 
+AD4 +AD4 Signed-off-by: Gokul Sivakumar +ADw-gokulkumar792+AEA-gmail.com+AD4
+AD4 +AD4 ---
+AD4 +AD4  bridge/bridge.c +AHw 2 +--
+AD4 +AD4  1 file changed, 1 insertion(+-), 1 deletion(-)
+AD4 +AD4 
+AD4 +AD4 diff --git a/bridge/bridge.c b/bridge/bridge.c
+AD4 +AD4 index f7bfe0b5..48b0e7f8 100644
+AD4 +AD4 --- a/bridge/bridge.c
+AD4 +AD4 +-+-+- b/bridge/bridge.c
+AD4 +AD4 +AEAAQA -149,9 +-149,9 +AEAAQA main(int argc, char +ACoAKg-argv)
+AD4 +AD4  			NEXT+AF8-ARG()+ADs
+AD4 +AD4  			if (netns+AF8-switch(argv+AFs-1+AF0))
+AD4 +AD4  				exit(-1)+ADs
+AD4 +AD4 +-		+AH0 else if (matches+AF8-color(opt, +ACY-color)) +AHs
+AD4 +AD4  		+AH0 else if (matches(opt, +ACI--compressvlans+ACI) +AD0APQ 0) +AHs
+AD4 +AD4  			+-+-compress+AF8-vlans+ADs
+AD4 +AD4 -		+AH0 else if (matches+AF8-color(opt, +ACY-color)) +AHs
+AD4 +AD4  		+AH0 else if (matches(opt, +ACI--force+ACI) +AD0APQ 0) +AHs
+AD4 +AD4  			+-+-force+ADs
+AD4 +AD4  		+AH0 else if (matches(opt, +ACI--json+ACI) +AD0APQ 0) +AHs
+AD4 +AD4 
+AD4 
+AD4 Another example of why matches needs to be deprecated.
+AD4 
+AD4 Re-assigned the set to Stephen for main tree.

Thanks, i will send a v3 patchset with the subject prefix +ACI-PATCH iproute2+ACI
instead of +ACI-PATCH iproute2-next+ACI after addressing Stephen's recent suggestion 
to remove the unnecessary is+AF8-json+AF8-context() condition checks from patch 2/3.

Gokul

