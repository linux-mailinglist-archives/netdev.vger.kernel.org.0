Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 621B826A53
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbfEVS5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:57:40 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42937 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728734AbfEVS5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:57:40 -0400
Received: by mail-qt1-f196.google.com with SMTP id j53so3689036qta.9
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 11:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=oySDxJ24n6nPmGUnr2lBYRSxZDeMKf9QC2CNXCWmWV4=;
        b=W9XIlx9D9zimHSxYcuMsHJzMb7PDKqw81SNUa3OQbeX2I6CBApKYZn/JLObVyP7Ekj
         mq30bZMn9e4CrsP7zow15wd/W9E49eg1tRLpnPWABnEwSUSCwObag9E9Q1SjTHc1iW5i
         waNqj4RFtA/UAHEw5EIHceI51sQQanQtZvTbih7TuZMmfAkN2CF44XTyY8yu95wA7l2D
         FlB/cYbtDGX+rmR8XRV9S53AOk+cUGxvWSbktUE33GVqDscQXRFqFxGQlYOxANAybjiv
         7QzY6pOXCL0ucYUX5TYCi12qpqeDu8enfYPF2KSSV3L09Woye75gpuPTh3UCCadHw1CM
         ZnqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=oySDxJ24n6nPmGUnr2lBYRSxZDeMKf9QC2CNXCWmWV4=;
        b=hvFe94AcMydyDAx9aJx9z+Bhx7kVe0D97TX4udYv3STXGonugWMImt3Lli7kLclrRk
         uJ+xG/bM+zmROip0Vn2m6J2UOa/1Ynfn1ZBsTJaa9h+jGYxD1YTyA+qXumOiIbdnUPDP
         DAJTpaErLi0HEIfeTxbounRqRk0ANT5DLxDNGa/zk9+KxDcNCpeRB1XiCmaUP20O4lXv
         xxcArAewNwA5X0dWYTpOTiCmXXPs8+YcSydL1H9D9rSlJIvIANmU0QFuAxdKM1htjAZr
         yD0CSlCmy+x0eU8WRpg3OXrjSo1jQyJCeRHLKB7qWqs5tUKXsj8tQi01e/PiehjY5sAi
         7Rug==
X-Gm-Message-State: APjAAAWwb01n4VYwN0aZawDqcjCiT+dWHZYwm72PT15ASv89BiJ1CMqG
        jDqcca25VkOdL4sLWnIcQZr+4g==
X-Google-Smtp-Source: APXvYqyf4eG3ZQ6ajCO2q7i3mQ3gMNJMTC+KVx0V6KEm1QpQBWAOWTaH7li+zvPhRaxHj+zs5080Uw==
X-Received: by 2002:ac8:2473:: with SMTP id d48mr21693417qtd.373.1558551459284;
        Wed, 22 May 2019 11:57:39 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n36sm15655520qtk.9.2019.05.22.11.57.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 22 May 2019 11:57:39 -0700 (PDT)
Date:   Wed, 22 May 2019 11:57:35 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Boris Pismenny <borisp@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "davejwatson@fb.com" <davejwatson@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "vakul.garg@nxp.com" <vakul.garg@nxp.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH net v2 3/3] Documentation: add TLS offload documentation
Message-ID: <20190522115735.48ee7d9d@cakuba.netronome.com>
In-Reply-To: <cda80559-7cac-ae0b-6a23-cec20c041732@mellanox.com>
References: <20190522015714.4077-1-jakub.kicinski@netronome.com>
        <20190522015714.4077-4-jakub.kicinski@netronome.com>
        <cda80559-7cac-ae0b-6a23-cec20c041732@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 May 2019 11:25:02 +0000, Boris Pismenny wrote:
> > +Performance metrics
> > +===================
> > +
> > +TLS offload can be characterized by the following basic metrics:
> > +
> > + * max connection count
> > + * connection installation rate
> > + * connection installation latency
> > + * total cryptographic performance
> > +
> > +Note that each TCP connection requires a TLS session in both directions,
> > +the performance may be reported treating each direction separately.
> > +
> > +Max connection count
> > +--------------------
> > +
> > +The number of connections device can support can be exposed via
> > +``devlink resource`` API.  
> 
> This is future changes, let's document when we implement this.

In what sense?  The devlink resource API exists today, and doesn't
require any infrastructure changes to report TLS table occupancy.
I think it's a good idea to point driver authors at this existing
infrastructure so they don't invent their own.  Even if no driver
today implements it.

> > +Known bugs
> > +==========
> > +
> > +skb_orphan() leaks clear text
> > +-----------------------------
> > +
> > +Currently drivers depend on the :c:member:`sk` member of
> > +:c:type:`struct sk_buff <sk_buff>` to identify segments requiring
> > +encryption. Any operation which removes or does not preserve the socket
> > +association such as :c:func:`skb_orphan` or :c:func:`skb_clone`
> > +will cause the driver to miss the packets and lead to clear text leaks.
> > +
> > +Redirects leak clear text
> > +-------------------------
> > +
> > +In the RX direction, if segment has already been decrypted by the device
> > +and it gets redirected or mirrored - clear text will be transmitted out.  
> 
> Not sure if it is a bug or a feature as it needs administrator 
> intervention ;)

Right, I'm not loosing that much sleep over this one :)

> Overall, looks good to me.
> Acked-by: Boris Pismenny <borisp@mellanox.com>

Thank you!!
