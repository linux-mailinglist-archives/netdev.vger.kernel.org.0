Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0E25A2222
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 19:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfH2RYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 13:24:15 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34059 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfH2RYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 13:24:14 -0400
Received: by mail-pg1-f195.google.com with SMTP id n9so1952537pgc.1;
        Thu, 29 Aug 2019 10:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=tbVm52sbCYygnxsvFx8xgew5SYJ1d2+HJkYkARR1mRc=;
        b=SuezRnkpMxROmN/SHpY5Md0c4ractqEcqbQLnbjlkAe0/C2ZgLLwiYoH5DAGhI8H5i
         AesXpgC775xDbQbFPJmbh50KDo5tGS4gOHWe27SdXsVRZuRqMLQSmC0xiApEe49gVik3
         sLq23RXk1jOu1aMLJMs3RlG1Hgew9fBiGfjGLhZGe+O+RnA6C4EJkDS4pQnwYMiUI9Ke
         ath8AboaemzRjIGqSbqAuA+9tlkZ5JyG+GBBt07SZEG8eiRDyNk96wTd6DNxKWidAwlR
         6etpkRJeRc4auI+lB42OSSZqAbhxuNB62tJTWnxcGfWoOGdCNMWtzyMzb6C4ASFzJ+7f
         UEZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=tbVm52sbCYygnxsvFx8xgew5SYJ1d2+HJkYkARR1mRc=;
        b=JYSwk0FDmz4Ycmph0qJ29osTTDFmOnTZLDnjstrxhSDTo3wz04o4VB+c0K24efc2US
         fbQd2s87PVHD08e/uLyM4vAeTqgpeae+LuTUBin8Ir66SDHSblyAc6N5/SFpuCowl73R
         FHmvCvokUqB0hPlOzTy8cdSgdNaLv2AMZPX2yvPC1DWmCSsAh4R8akb7C6b3SzvJmmH8
         GNuWnYAVDfNHKwrCT279xDGSccIf6aW643Lza7yBWRN1TYj9R7lSudvZDFuq5/MPoFuo
         kuMUE+LDOnRzj2/wEMIDpJDtXPbvOBvu+hCZqzk3sD9JpzL2KhcS706bzeozzHALQ8wa
         tP7w==
X-Gm-Message-State: APjAAAUCpUGXlY7yaiyFOSp9xy68thEnYqmccwdvJkYSXndJxcJ3oQ8q
        apfTO+vKJ+2Njm8QgL0DhvY=
X-Google-Smtp-Source: APXvYqz1qyzrHqwkUegxvwfI1STmPkuqXeFyUxoUfAVWjiQ+MMPsms1h44tNEPPg5KUEgG9MQqOMKg==
X-Received: by 2002:a63:a35c:: with SMTP id v28mr9417712pgn.144.1567099453842;
        Thu, 29 Aug 2019 10:24:13 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:1347])
        by smtp.gmail.com with ESMTPSA id p90sm8579670pjp.7.2019.08.29.10.24.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 10:24:12 -0700 (PDT)
Date:   Thu, 29 Aug 2019 10:24:11 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net,
        davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and
 CAP_TRACING
Message-ID: <20190829172410.j36gjxt6oku5zh6s@ast-mbp.dhcp.thefacebook.com>
References: <20190829051253.1927291-1-ast@kernel.org>
 <87ef14iffx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ef14iffx.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 09:44:18AM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <ast@kernel.org> writes:
> 
> > CAP_BPF allows the following BPF operations:
> > - Loading all types of BPF programs
> > - Creating all types of BPF maps except:
> >    - stackmap that needs CAP_TRACING
> >    - devmap that needs CAP_NET_ADMIN
> >    - cpumap that needs CAP_SYS_ADMIN
> 
> Why CAP_SYS_ADMIN instead of CAP_NET_ADMIN for cpumap?

Currently it's cap_sys_admin and I think it should stay this way
because it creates kthreads.

