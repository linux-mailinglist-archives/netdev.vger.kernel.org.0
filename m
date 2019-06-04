Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F9335090
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 22:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfFDUE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 16:04:28 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45233 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDUE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 16:04:28 -0400
Received: by mail-qk1-f193.google.com with SMTP id s22so3680282qkj.12;
        Tue, 04 Jun 2019 13:04:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kRWHmlTazXX9nh3l+uCl+QUYh7joRupEOxTxYsi6yow=;
        b=SXym818ZY4smWXmvcE8o6563iTfvy9jWjvzneIlUJ0KNSaAYSAvPo6xhPb+Wz/Wts4
         BNe5iFhu64pMgFczNJCTLx/iPJqLtHERbO9poa/paXZZ/nA2Y+1ZTleHYf96HT30TAdC
         FXvJPtekAFeA5MwxyytMoCoYyx/LP6PBev3VZHIkdq6u5SWoZo7dvzHiq5VqQACnF2fV
         erBgkR/gsR0mAC8Bx5IWH8+IyQW/9bEDCgu2IsIavL4BS89bXdu0Q4Ao1K8LyBxArK13
         ml6HdIdwmtOwW3x59uzxTA5lKiTl2v5V+QE2U0/S6jScsSywwbbsCZc2Fdmae2DlFe8s
         S7kg==
X-Gm-Message-State: APjAAAWUwLJ/K1XrwnSPzN4kl9/FZxIUNPxdpd4NPjXSbiRoLL95LgZu
        il7lndNrbyezfTu1dC/igIWHROGbC+dD9OxK1aI=
X-Google-Smtp-Source: APXvYqyofKzA14lv2A+QgH4Q7Jn1VXFGegI/NwNXTI2mi6UtDhR9SWuQ11u/xLdSZRSY6UUR1nNt+brbqwKzA9VWtmY=
X-Received: by 2002:a37:a4d3:: with SMTP id n202mr28029003qke.84.1559678666645;
 Tue, 04 Jun 2019 13:04:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190531035348.7194-1-elder@linaro.org> <e75cd1c111233fdc05f47017046a6b0f0c97673a.camel@redhat.com>
 <065c95a8-7b17-495d-f225-36c46faccdd7@linaro.org> <CAK8P3a05CevRBV3ym+pnKmxv+A0_T+AtURW2L4doPAFzu3QcJw@mail.gmail.com>
 <a28c5e13-59bc-144d-4153-9d104cfa9188@linaro.org> <20190531233306.GB25597@minitux>
 <d76a710d45dd7df3a28afb12fc62cf14@codeaurora.org> <CAK8P3a0brT0zyZGNWiS2R0RMHHFF2JG=_ixQyvjhj3Ky39o0UA@mail.gmail.com>
 <040ce9cc-7173-d10a-a82c-5186d2fcd737@linaro.org> <CAK8P3a2U=RzfpVaAgRP1QwPhRpZiBNsG5qdWjzwG=tCKZefYHA@mail.gmail.com>
 <b26cf34c0d3fa1a7a700cee935244d7a2a7e1388.camel@redhat.com>
In-Reply-To: <b26cf34c0d3fa1a7a700cee935244d7a2a7e1388.camel@redhat.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 4 Jun 2019 22:04:09 +0200
Message-ID: <CAK8P3a3pQpSpH4q=CL6gr_YzjYgoyD6-eyiLrvnZsqqjpcRxtQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Dan Williams <dcbw@redhat.com>
Cc:     Alex Elder <elder@linaro.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        David Miller <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        evgreen@chromium.org, Ben Chan <benchan@google.com>,
        Eric Caruso <ejcaruso@google.com>, cpratapa@codeaurora.org,
        syadagir@codeaurora.org, abhishek.esse@gmail.com,
        Networking <netdev@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 5:18 PM Dan Williams <dcbw@redhat.com> wrote:
> On Tue, 2019-06-04 at 10:13 +0200, Arnd Bergmann wrote:
> >
> > Can you describe what kind of multiplexing is actually going on?
> > I'm still unclear about what we actually use multiple logical
> > interfaces for here, and how they relate to one another.
>
> Each logical interface represents a different "connection" (PDP/EPS
> context) to the provider network with a distinct IP address and QoS.
> VLANs may be a suitable analogy but here they are L3+QoS.
>
> In realistic example the main interface (say rmnet0) would be used for
> web browsing and have best-effort QoS. A second interface (say rmnet1)
> would be used for VOIP and have certain QoS guarantees from both the
> modem and the network itself.
>
> QMAP can also aggregate frames for a given channel (connection/EPS/PDP
> context/rmnet interface/etc) to better support LTE speeds.

Thanks, that's a very helpful explanation!

Is it correct to say then that the concept of having those separate
connections would be required for any proper LTE modem implementation,
but the QMAP protocol (and based on that, the rmnet implementation)
is Qualcomm specific and shared only among several generations of
modems from that one vendor?

You mentioned the need to have a common user space interface
for configuration, and if the above is true, I agree that we should try
to achieve that, either by ensuring rmnet is generic enough to
cover other vendors (and non-QMAP clients), or by creating a
new user level interface that IPA/rmnet can be adapted to.

       Arnd
