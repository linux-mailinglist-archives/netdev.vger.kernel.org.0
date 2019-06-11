Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB8A3D661
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 21:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392581AbfFKTDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 15:03:39 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44563 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392561AbfFKTDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 15:03:37 -0400
Received: by mail-pf1-f196.google.com with SMTP id t16so7999645pfe.11;
        Tue, 11 Jun 2019 12:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TINH5Zv9sdfI5yGkKfukd7zEs5gc5SFmFE6Rm33jogw=;
        b=sTbvzg1IBs2bb8cjreY5cBasSaH+2pFI5pjQ35wagL+18kPnXLznCC9TyL/tH+M4hP
         q8EzAGJHmuFs3cTKR1D9zefrPRRKJAU8/AOrhIRoejq49CWhnsGswe/IoyW+3pLcVrZA
         idoBHD6D/SGQjCHVkxMcAuSa0qZ0UYf6PuryCCl6KxGiUpZO9zLoZB/vD1r7/EDrA+xH
         AVkmXuIzCTP0+FrXVOmES1ohd6KLAjLFxCArXYNa/4QqLSZCec9i31IIvqj3lneR3rck
         uR0BMYPVVBv3BGDTkrSUVMI/X2O/9KCPcGFl11pf9di+5Ug8qf/qOIO7Nn2RveaTofno
         9dig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=TINH5Zv9sdfI5yGkKfukd7zEs5gc5SFmFE6Rm33jogw=;
        b=kJdY8QEZIURUZo4HI1IMAJ31YHhLhQOT0JyIu/z4oYMmnbIh1Ilp/5D9gBJ2+bbLqB
         5Q22m9UZxg/2wjx18KoAlemA0HzDVaq3nVT+9VyDgdSYq1SK5N7ebdKeg+Rt1lMZzobi
         hGcB+RMX6DktW7sarEbF71v5XQAxCVDAH8yz5fQK69APpzVbgkbK/ZA1O6BNM9zoRs6+
         0hcoCcEr1vSsYC71cLuW5tIRcPV5oDbmICNsHFaZ0bez9YuMImM5ODYQz4uKJyzSb+ag
         r5jSLR6nG3BjIJuDbVMpdpvVAzkhAyUntQu9wtLj+V1Fh3ZBp5SWZ7sANUrMk91gklD7
         gzrA==
X-Gm-Message-State: APjAAAVS0gNjm+B+VuYHMOfqp2tgCNkDmwHjfOTQ+qEzcxJQyzMSOBVO
        WBXvuDv6lyEDMAXDFqdXWXg=
X-Google-Smtp-Source: APXvYqyurkJYg+ONU24NoQH+aOpKIHaCcBkqNsSi7eK6I99H2KHZq5aZwOzTKoSX9JiYUzkROPsUWw==
X-Received: by 2002:a62:6d47:: with SMTP id i68mr82880905pfc.189.1560279816496;
        Tue, 11 Jun 2019 12:03:36 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::2:1677])
        by smtp.gmail.com with ESMTPSA id y22sm12843821pgj.38.2019.06.11.12.03.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 12:03:35 -0700 (PDT)
Date:   Tue, 11 Jun 2019 12:03:32 -0700
From:   Tejun Heo <tj@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-block@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v3 05/33] docs: cgroup-v1: convert docs to ReST and
 rename to *.rst
Message-ID: <20190611190332.GI3341036@devbig004.ftw2.facebook.com>
References: <cover.1560045490.git.mchehab+samsung@kernel.org>
 <79865a4248ce5b042106e5ec69bb493292a8d392.1560045490.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79865a4248ce5b042106e5ec69bb493292a8d392.1560045490.git.mchehab+samsung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 08, 2019 at 11:26:55PM -0300, Mauro Carvalho Chehab wrote:
> Convert the cgroup-v1 files to ReST format, in order to
> allow a later addition to the admin-guide.
> 
> The conversion is actually:
>   - add blank lines and identation in order to identify paragraphs;
>   - fix tables markups;
>   - add some lists markups;
>   - mark literal blocks;
>   - adjust title markups.
> 
> At its new index.rst, let's add a :orphan: while this is not linked to
> the main index.rst file, in order to avoid build warnings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Please feel free to route with the rest of the series.  If you want
the patch to be routed through the cgroup tree, please let me know.

Thanks.

-- 
tejun
