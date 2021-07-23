Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317F73D31E3
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 04:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhGWBxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 21:53:31 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:50821 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233433AbhGWBxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 21:53:30 -0400
Received: by mail-pj1-f43.google.com with SMTP id l19so318512pjz.0;
        Thu, 22 Jul 2021 19:34:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RREWwRklaZFXt0C4quifntpsOFbK/AfnI0Sh0jnaUmg=;
        b=U03foEPWsW2DfPCXBxWAflP/v0TXNeTiZkUSRDn3VN4ryGn2q1oioraLyzQxaRIx7R
         awEPJuRcccvHB7WoD+0QvyhTsUyZ+FK8rl68oDrcv/XPnyY/ucLNjE5iEiwgR6TvnfNu
         VCv/jfbj+e5Fo/ThqnMtwvR+iseWt54tz0bOxbwXBkP/oQvcCayKqxbqTYiDXeyon0f6
         Tq7JG1KJBxHi50Cu8nMWsAdjb/zwpX0oeM1DD/HUs1osnfl54XHm8Osi6NQQ/rhnPHiE
         liIKV1aYYS81X22fSSPU5eZiChDTjru+RihbX90NZBlgISH8HcYcW+/h4dIGE+D3Lfae
         ch0g==
X-Gm-Message-State: AOAM5304ajlCpEutEqEN+cM2cENxloaRbWMVqn9Wr/G3u9ksY1/K36Dl
        1GfmY6FoQ6MGsnxFVhO4EIgM/kgwF5Gqgg==
X-Google-Smtp-Source: ABdhPJzjHKo0c5RWosVq5DDhWmIZFHW08248o5ty3hGtbxQ6eznyCONZvxh4FQ926BfpYN3JbCEfbg==
X-Received: by 2002:a17:902:b188:b029:11b:1549:da31 with SMTP id s8-20020a170902b188b029011b1549da31mr2169395plr.7.1627007642006;
        Thu, 22 Jul 2021 19:34:02 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:286e:6a9d:f340:dcd9? ([2601:647:4000:d7:286e:6a9d:f340:dcd9])
        by smtp.gmail.com with ESMTPSA id s7sm30561921pfk.12.2021.07.22.19.33.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 19:34:00 -0700 (PDT)
Subject: Re: [PATCH] kernel/module: add documentation for try_module_get()
To:     Luis Chamberlain <mcgrof@kernel.org>, gregkh@linuxfoundation.org,
        tj@kernel.org, shuah@kernel.org, akpm@linux-foundation.org,
        rafael@kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, andriin@fb.com, daniel@iogearbox.net,
        atenart@kernel.org, alobakin@pm.me, weiwan@google.com,
        ap420073@gmail.com
Cc:     jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210722221905.1718213-1-mcgrof@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2e9f16ad-5668-f15d-b3c3-f787ba55bcda@acm.org>
Date:   Thu, 22 Jul 2021 19:33:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210722221905.1718213-1-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/21 3:19 PM, Luis Chamberlain wrote:
> + * The real value to try_module_get() is the module_is_live() check which
> + * ensures this the caller of try_module_get() can yields to userspace module
> + * removal requests and fail whatever it was about to process.

can yields -> can yield?

Otherwise this looks really well written to me.

Bart.
