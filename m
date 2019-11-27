Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1BC10AD4E
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 11:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfK0KLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 05:11:36 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:47331 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbfK0KLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 05:11:35 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 1c62c338;
        Wed, 27 Nov 2019 09:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :from:date:message-id:subject:to:cc:content-type; s=mail; bh=H/2
        TV2MxQYedUOMP0EM40IR8Tgg=; b=oVoLagvGHi4VXayeB80oWfEj502XWCUPWfR
        Y2kTtxdQzKbeBEKF94bVi83o5lF0kIynz2HnQfQ12bnxlG21FCXDlpKtNllUk+KL
        bbDwxpFVYDouDcq3A9j81zN5418GFc/517ceqaUycMfylWB4mdV6qjABjXV9xdTn
        b6+8vAznmCytmCRrxFotRuDwkIUqmeq10OUm2PdqI233mXUMFtAFQqFQqCfeWWTk
        7Xa6Rm4X5IXre6GNHdIHQpUzJto8wjyUPOXSzz581kEm4xLWnvVQKHJ62VN/SESt
        RIHtkoQZhQqp6SjiZsRcoILP8vHT5Pa8NZ3/NdFmM+tw5wGF92A==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e76dd23a (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 27 Nov 2019 09:17:42 +0000 (UTC)
Received: by mail-ot1-f48.google.com with SMTP id c19so18619458otr.11;
        Wed, 27 Nov 2019 02:11:32 -0800 (PST)
X-Gm-Message-State: APjAAAVef9DX94dVUFa8zniNbOsLM/JTIbzhqCmSR1hoIURbjcKlb7hy
        hcSmr82rsJnCsl9/3kcBZLNFNsb6hLbogu4U+0s=
X-Google-Smtp-Source: APXvYqyb+jh8I3J4U6Mx2EmR5fklPzdDYSz9uwmcfqHD+AVCaJnyGF6tmET9nrJON87tEI0oC+TYgVwznTMUwgNwLp4=
X-Received: by 2002:a9d:12ae:: with SMTP id g43mr2930931otg.243.1574849491454;
 Wed, 27 Nov 2019 02:11:31 -0800 (PST)
MIME-Version: 1.0
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 27 Nov 2019 11:11:20 +0100
X-Gmail-Original-Message-ID: <CAHmME9oqT_BncUFaJRpj0xtL1MPcE=g5WQG_qE7oC231USQCPA@mail.gmail.com>
Message-ID: <CAHmME9oqT_BncUFaJRpj0xtL1MPcE=g5WQG_qE7oC231USQCPA@mail.gmail.com>
Subject: WireGuard for 5.5?
To:     Netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Dave,

It looks like Frankenzinc has landed in Herbert's crypto-2.6.git tree,
and he'll be pushing to Linus quite soon. The fact that there are two
separate trees means that I've missed your net-next cut this Monday,
due to waiting for these pieces to be in place. But I was wondering if
we could do some juggling so that WireGuard doesn't take ~135 days
from now to be released in 5.6, but rather sooner in 5.5. I suspect
this would entail: Herbert pushes to Linus, you pull from Linus, I
submit on top of your tree, you push back to Linus. I realize that
this isn't the ordinary procedure, and if you prefer to do things in
the ordinary way, that's fine and I understand. But in case you're as
excited as I am about getting WireGuard out the door at long last,
maybe we can try to handle this cross-tree situation with
crypto-2.6.git?

Jason
