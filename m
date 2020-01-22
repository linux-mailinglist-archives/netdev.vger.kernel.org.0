Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25126145B9D
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 19:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgAVSbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 13:31:33 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:36899 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgAVSbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 13:31:33 -0500
Received: by mail-yb1-f193.google.com with SMTP id o199so300902ybc.4
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 10:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mD0Xm4DLIJh48P4iVE8GoJNH5dZLVXVE/SNgw9dndN8=;
        b=eDtg4HE3btXcN35ljpKtq8AbHm6ltVoIl2/srj81KtZlC+N4dC/g5hAM1F0Q/Z9Oez
         qe7FoSTFN2A+ELXDAvMhZJuVPpqnlzP3ReJ39M9BGyYVpWj/UMKBbnuJCIKxdw3JQwdB
         zJcaxcTPsUMb+oXUJPMLRiwQawW29fQsqNBclFIo2lBsyHtTTRca9H+c+RDIZX2Vt3Z6
         2UWeWepq4hBVsqMo5xcAhcXuC5lZaXWevsDWRR2ulsipsbX6+mX6LI9CWw1MbmgAsc3j
         keT0bqDEy8fR/zMI/Oi1hmSL3ZneIWHh6fHsZ/ib/JGLd5CYMGS+eXObjJy+YGy4Gops
         7qsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mD0Xm4DLIJh48P4iVE8GoJNH5dZLVXVE/SNgw9dndN8=;
        b=bHkGxsyQoS+swiiheWD6w+lEYDDCLC20h4tGhteg6/0usxB3pttH0IkdnFNHxZiLHp
         t2pOSCFYv12BXznqaqKn4ggXxilVJaWv4Rc7efXmrBtbcr8LCSwZGNS27vIHBVi0ouY3
         f0XTKdCHG5tYn7AVuSRbb2s5R9ig3QrfFkpP2LIf1sCqkJqWfr7Q/543RlKUMej5VKVM
         apIaoO3uRURe15edrgK/0dZGE0LotY8jX3uMr+qg3FcEzwybkRq5HaVGSLs25rPmsjyG
         adsQ6NcKuwqhgIj5je29LBiKQreunVQj/OSlEfm/A5W/Wt2gJlWfCl1i2t9KeSO2K+VS
         1j0g==
X-Gm-Message-State: APjAAAXswxPg4YrOZJVPpBm/RAd/x4CQAeWsz0Q7sQ6016MVQnzWfhWi
        vwKv2qzvl3xqMOIA56dc3BRSaJw9
X-Google-Smtp-Source: APXvYqwjIgyoORlTy6x6XliUAPP4JZo7JhF+qzkW3pXsk/Bls/6tVv6qPyGTnNrZ0QabNOHoRsfhCw==
X-Received: by 2002:a25:7452:: with SMTP id p79mr8961013ybc.150.1579717891884;
        Wed, 22 Jan 2020 10:31:31 -0800 (PST)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id w74sm19285158ywa.71.2020.01.22.10.31.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 10:31:30 -0800 (PST)
Received: by mail-yb1-f178.google.com with SMTP id n66so312657ybg.0
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 10:31:30 -0800 (PST)
X-Received: by 2002:a25:5945:: with SMTP id n66mr9035395ybb.337.1579717889697;
 Wed, 22 Jan 2020 10:31:29 -0800 (PST)
MIME-Version: 1.0
References: <cover.1579624762.git.martin.varghese@nokia.com> <946031c56fa58d24f4a7ab45cbc6dfc9e42c8106.1579624762.git.martin.varghese@nokia.com>
In-Reply-To: <946031c56fa58d24f4a7ab45cbc6dfc9e42c8106.1579624762.git.martin.varghese@nokia.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 22 Jan 2020 13:30:53 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdvC+7MuEPnB2kUxx+L5170SxEP1Gn6AfN5v6e5_RqcvQ@mail.gmail.com>
Message-ID: <CA+FuTSdvC+7MuEPnB2kUxx+L5170SxEP1Gn6AfN5v6e5_RqcvQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/2] net: Special handling for IP & MPLS.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 12:51 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> From: Martin Varghese <martin.varghese@nokia.com>
>
> Special handling is needed in bareudp module for IP & MPLS as they
> support more than one ethertypes.
>
> MPLS has 2 ethertypes. 0x8847 for MPLS unicast and 0x8848 for MPLS multicast.
> While decapsulating MPLS packet from UDP packet the tunnel destination IP
> address is checked to determine the ethertype. The ethertype of the packet
> will be set to 0x8848 if the  tunnel destination IP address is a multicast
> IP address. The ethertype of the packet will be set to 0x8847 if the
> tunnel destination IP address is a unicast IP address.
>
> IP has 2 ethertypes.0x0800 for IPV4 and 0x86dd for IPv6. The version
> field of the IP header tunnelled will be checked to determine the ethertype.
>
> This special handling to tunnel additional ethertypes will be disabled
> by default and can be enabled using a flag called ext mode. This flag can
> be used only with ethertypes 0x8847 and 0x0800.
>
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

Acked-by: Willem de Bruijn <willemb@google.com>
