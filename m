Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0775195E2
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 02:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfEJAAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 20:00:35 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40147 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfEJAAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 20:00:34 -0400
Received: by mail-pg1-f194.google.com with SMTP id d31so2027984pgl.7;
        Thu, 09 May 2019 17:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=dChVqTviUJZkhAEyGEloPZUsbHeVi+nAadOc17lt/xI=;
        b=F8YiX69wMj6uWvqG2gj8rKD+5JmXiGDvRhtfdWy7mtV4/+PV9t2Gswew4nGi+VrSMw
         VP+qiGJpDxrx17QBJQYFkLDpPg6Fdd0PceCoPIXyh1/7Rkk9G65Nc3Fmd6a6/2WrtLja
         N53kTp0zZWxOEAw0sTOGCrvxsng/iIjvQ521OoNTKoVdjLz8zsTHW/q0IkJZTZygapzj
         govaj2K6lqprTecx4biOocaOEUBt/DaMXbNZ0R7UKsrVf4sr8UDCkjRTv7f+ZF6hly2M
         atatsJ0iDQ4SSC06pbmOTDDFMtU1puaTBZp84W/FVFpOiKM6NgaTl6STaSR+5FULa9I5
         XQyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=dChVqTviUJZkhAEyGEloPZUsbHeVi+nAadOc17lt/xI=;
        b=LaHPBeqcmNAyt6DeRGaaH3IBkPJsH/22xbnrVNCllQ/nMUCO4UkgluGUDBVaYcITHL
         A+bwZb1NzRUMs+4M7k/PlkpOCuA8aeBS0xKSdj6kXk95PGf79qTUOJ1NKyFNWUqF3H2v
         MYPJXC08jRl7btl52+2tWA7rjVu7PzKHnyA1Vy8203X+JVp49tE5Pi7HdGAKcecd1lRp
         19qzs3MEhpuKu/1GGYI4bXk827/YkWxfDxiCn4sgSQgn6nAGznz3T5p5kvq7fSRV8edJ
         usnnjcNw++2Hx58JCq68+pIrKPnZfhbpIIA5zTGcbvBQT70gPKaGEO2bgCv5iCW7xmYC
         M1Gg==
X-Gm-Message-State: APjAAAVJs7qZFfdD1jjfhns1usXrySv8f1PQc3XXb7+aRyVcbWc1LSnN
        GHJIXFF9MeI3kEokVT3xeIA=
X-Google-Smtp-Source: APXvYqy/JgDoQjdsf4op7BILs++mEfq/winhdVwvj+maESKvfRaXlBFJOw539wdBqfKBpU78/4H/Rw==
X-Received: by 2002:a63:1d05:: with SMTP id d5mr9280001pgd.157.1557446433356;
        Thu, 09 May 2019 17:00:33 -0700 (PDT)
Received: from ip-172-31-29-54.us-west-2.compute.internal (ec2-34-219-153-187.us-west-2.compute.amazonaws.com. [34.219.153.187])
        by smtp.gmail.com with ESMTPSA id u7sm4342389pfu.157.2019.05.09.17.00.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 17:00:32 -0700 (PDT)
Date:   Fri, 10 May 2019 00:00:30 +0000
From:   Alakesh Haloi <alakesh.haloi@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] selftests/bpf: Fix compile warning in bpf selftest
Message-ID: <20190510000030.GA81841@ip-172-31-29-54.us-west-2.compute.internal>
References: <20190507231224.GA3787@ip-172-31-29-54.us-west-2.compute.internal>
 <CAADnVQ+e6TW9cH6yDmRSG5pRHXJiZajcx_q9SoPQi1keDROh-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQ+e6TW9cH6yDmRSG5pRHXJiZajcx_q9SoPQi1keDROh-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 09, 2019 at 01:51:54PM -0700, Alexei Starovoitov wrote:
> On Tue, May 7, 2019 at 4:12 PM Alakesh Haloi <alakesh.haloi@gmail.com> wrote:
> >
> > This fixes the following compile time warning
> >
> > flow_dissector_load.c: In function ‘detach_program’:
> > flow_dissector_load.c:55:19: warning: format not a string literal and no format arguments [-Wformat-security]
> >    error(1, errno, command);
> >                    ^~~~~~~
> > Signed-off-by: Alakesh Haloi <alakesh.haloi@gmail.com>
> > ---
> >  tools/testing/selftests/bpf/flow_dissector_load.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/flow_dissector_load.c b/tools/testing/selftests/bpf/flow_dissector_load.c
> > index 77cafa66d048..7136ab9ffa73 100644
> > --- a/tools/testing/selftests/bpf/flow_dissector_load.c
> > +++ b/tools/testing/selftests/bpf/flow_dissector_load.c
> > @@ -52,7 +52,7 @@ static void detach_program(void)
> >         sprintf(command, "rm -r %s", cfg_pin_path);
> >         ret = system(command);
> >         if (ret)
> > -               error(1, errno, command);
> > +               error(1, errno, "%s", command);
> >  }
> 
> it was fixed month ago.
The warning is seen in mainline. I did not try bpf tree. Looks like it
is fixed there. 

Thanks
-Alakesh
