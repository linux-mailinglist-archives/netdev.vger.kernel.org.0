Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6ED7046F
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 17:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730194AbfGVPsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 11:48:18 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33173 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbfGVPsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 11:48:18 -0400
Received: by mail-pl1-f194.google.com with SMTP id c14so19323071plo.0;
        Mon, 22 Jul 2019 08:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=v9CeHsrmNK4u791PGt6HLt7yZpY8YH1M1iihgCmbeEo=;
        b=j1dj7TjAWLbPfTqESS9vwcj4duHRd9TFsFSVyuqXnaY8X5E+xBCCF9MKSx/pFL33N/
         UNNgWfOulFWmWqz62vJCxun4FFlgg9H7F13OtTY5mT8jTmGRsy8tPfDbBQCOAejMVB7t
         RvgqfrQjO3Vgu4PtuRUB4ByypEbWTxRVHumcqeQizbp/WoFpI1bNf/Y1GggwyeZ0EKP1
         ybmwAoCNRuuckX3MqZOyz7xcyEt9yb4jHEPW4IE7Tr06o9rSgn1XEvNDPczMz6tewm7Z
         t32xPt+wbAVujaLiMyR9D8pAK6FAMA4tSgixMAdL8dpJZVFxnDQODpBYwTPIw7jZFLp9
         m/qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=v9CeHsrmNK4u791PGt6HLt7yZpY8YH1M1iihgCmbeEo=;
        b=T3JpCgp7IceJ0sKt4RNbtEcaoznls34Z4/uevBAScqUUw8rhmB8ZjO84/zx8ohVRgS
         DOR/g6F3r+E8IGDIFCvkVedjQlGkCtiVCiHcu4ZjU6f4SKoaic4Xt3G40qu4AtiAXmBq
         mK9Rt97EbcJhVRD3cLYYds57UB6aXamWxPSGniflC9fBSTZoSo9kayNVVfZvKYoaf+Aw
         ClVCII9gU/CtHyhMYUWqpcFhOc7PHKEtSwCE6uSYe/JFdEkiHCMtC5hlaNZWW5ZkecYV
         ckC88gHfmju2keHqhf5szcTkLhnqSgGR8gaw+4rhDsPCIlRPJ9Vx6endp5/EaYBehDkj
         FgOg==
X-Gm-Message-State: APjAAAWe79C24/bnYh9EW6UeRTopKoHDR/4CSg1acQUUSa20qi4oPrMB
        +hxFvf4g2Fi93zYTiyWbZgw=
X-Google-Smtp-Source: APXvYqyZSc9krNvFfN+EEqb8WQ3eDD7gaJMKUDpZmhq6o2o/7CLargLgebHOrdManbHZ5rOmW8/53A==
X-Received: by 2002:a17:902:9689:: with SMTP id n9mr77044735plp.241.1563810497490;
        Mon, 22 Jul 2019 08:48:17 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h26sm43201717pfq.64.2019.07.22.08.48.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 08:48:17 -0700 (PDT)
Date:   Mon, 22 Jul 2019 08:48:09 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        john.fastabend@gmail.com, alexei.starovoitov@gmail.com
Cc:     edumazet@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@netronome.com
Message-ID: <5d35dab9cea9_7cd82abccab905bc13@john-XPS-13-9370.notmuch>
In-Reply-To: <3c97d252-37ad-302f-b917-e7ea6e819318@iogearbox.net>
References: <20190719172927.18181-1-jakub.kicinski@netronome.com>
 <20190719103721.558d9e7d@cakuba.netronome.com>
 <3c97d252-37ad-302f-b917-e7ea6e819318@iogearbox.net>
Subject: Re: [PATCH bpf v4 00/14] sockmap/tls fixes
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> On 7/19/19 7:37 PM, Jakub Kicinski wrote:
> > On Fri, 19 Jul 2019 10:29:13 -0700, Jakub Kicinski wrote:
> >> John says:
> >>
> >> Resolve a series of splats discovered by syzbot and an unhash
> >> TLS issue noted by Eric Dumazet.
> > 
> > Sorry for the delay, this code is quite tricky. According to my testing
> > TLS SW and HW should now work, I hope I didn't regress things on the
> > sockmap side.
> 
> Applied, thanks everyone!

Thanks Jakub, for the patches without my signed-off already

Acked-by: John Fastabend <john.fastabend@gmail.com>
