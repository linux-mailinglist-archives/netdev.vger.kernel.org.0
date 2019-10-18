Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82451DBC47
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 07:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441920AbfJRFAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 01:00:19 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:41558 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfJRFAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 01:00:19 -0400
Received: by mail-pg1-f176.google.com with SMTP id t3so2649322pga.8;
        Thu, 17 Oct 2019 22:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hkRzongkuOUe83ChWkL44NvN9Te54QbJ4HXExHzR2dY=;
        b=jatNbz0IMlnkkWt3Xg1ggLGyaO+fIaHEXiyAghJ3oj3XGcTM6ib5fXHRjNOMzSfc4i
         vCGp5w1Z+JLotu0IymLr1p0tRWNP7CE0HJgfQHkCoZlqf1NltbKigkHVou6QPc5+xzcG
         Ww7lLxU48nRRFiQuTCC1TPVDsWKgpHK0/dVgJrMSojuoJrL5UpXHuK31cxiPqs1gQSJS
         vyxwxHLJ3L3U3jWa10U+hHtsRIlCqeD4B0R6bWzLub+bEXq28Ws5rcGM/JIM9JVLxmQw
         BlqDV8QwxTIGdGa42EtKB6wDuHg84K2VTcc4AcfkL5/cjszzprioS+kQ2JoyiJeHb3Bi
         ut3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hkRzongkuOUe83ChWkL44NvN9Te54QbJ4HXExHzR2dY=;
        b=ZB6qLK+Rj3bFNulOGUkke6WTqYS7bmQStwEE+tqQgTkK1afgpTYhXx+/zb5bHdk390
         KUpxi6j0Zc4R+dAN45RmugCVQR7eiyQ3gIlFsNmZq/Zi9PTMhCrQ7S+Vf0s5CI/aotul
         FIbnZH4BpSbiLMfsI7cSsd4Wn8V4GD4ONsLyreXMy6aGwoVxWxiOuoJ37RF9gOhry9HM
         OFhGL8688mjjXObw4eVE8y3EVVIuH9d45nr7O2Sv2bSbCfVXPo6tr7jqf035VxX9gn8L
         JMDL2FdfPz9kFyIq8hzr48Sm3d+UZbVI0oVg5mZ2LAuiyj2uuB6knmCM/jXk2Z68mpOK
         fj6Q==
X-Gm-Message-State: APjAAAUvc6jVZUI1Tj19a53uFDv81RcXMiLWsbGfnbBdNXxMQ+T1nzm9
        /1Kaq7sb1xnr5VjTPpHS2z0=
X-Google-Smtp-Source: APXvYqwaO3NXr1IrOUdk7COhtE8etBUdbbxwgbUaqCWe2dBM2NF7UNRJQNPJdNWWjJt44Zo+wGuoMQ==
X-Received: by 2002:aa7:8691:: with SMTP id d17mr4373530pfo.218.1571374818508;
        Thu, 17 Oct 2019 22:00:18 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::cfd0])
        by smtp.gmail.com with ESMTPSA id r24sm4564056pfh.69.2019.10.17.22.00.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 22:00:17 -0700 (PDT)
Date:   Thu, 17 Oct 2019 22:00:15 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: linux-next: manual merge of the tip tree with the net-next tree
Message-ID: <20191018050013.sle55bwea5kxovej@ast-mbp>
References: <20191018133139.30c88807@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018133139.30c88807@canb.auug.org.au>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 01:31:39PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in:
> 
>   samples/bpf/Makefile
> 
> between commit:
> 
>   1d97c6c2511f ("samples/bpf: Base target programs rules on Makefile.target")
> 
> from the net-next tree and commit:
> 
>   fce9501aec6b ("samples/bpf: fix build by setting HAVE_ATTR_TEST to zero")
> 
> from the tip tree.

Argh.
Can tip folks revert the patch and let it go the normal route via bpf trees?
There was no good reason in creating such conflicts.

