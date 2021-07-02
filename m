Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50903BA30F
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 18:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhGBQKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 12:10:32 -0400
Received: from www259.your-server.de ([188.40.28.39]:54474 "EHLO
        www259.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhGBQKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 12:10:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=waldheinz.de; s=default1911; h=MIME-Version:Content-Type:In-Reply-To:
        References:Subject:Cc:To:From:Message-ID:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=hWt17Shkuog8hefVCxJUntGf6/HLr5wdnQGS2wj7iuU=; b=RC5ZjxwoL0R3e0YelkR4/L5oW/
        DAOvoftFt5Cp9AF431KKPDxtckbhh3gDM+NqIWli5j+LJZuZVdBLVE/ztIb9JWuyhzVHe0F2N86HN
        QV14FF9IM/TA8ONSKPkGX1TLXzu+LMgnP1LOFawTFJOEYc2x4+x8iZiepRg881DlfLsEFpTdm9sbF
        Z2QoUR/cWIsD5EGIKED08f8ijzvp1S/cUaAaFATE3XiZ6+k94q+48V+dGebuerZs2goS4ZP2A74Ol
        UEvQPVacHs0G9C43tApNta4C90O4t9trayYhirbmbayMmnKr4nGjoGsU68ro16G3QaIolJnP6Lmbh
        2xzbcWUg==;
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www259.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <mt@waldheinz.de>)
        id 1lzLhn-0009hO-KU; Fri, 02 Jul 2021 18:07:51 +0200
Received: from [192.168.0.32] (helo=mail.your-server.de)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-CHACHA20-POLY1305:256)
        (Exim 4.92)
        (envelope-from <mt@waldheinz.de>)
        id 1lzLhn-000Wz4-Bs; Fri, 02 Jul 2021 18:07:51 +0200
Received: from ip4d1584d2.dynamic.kabel-deutschland.de
 (ip4d1584d2.dynamic.kabel-deutschland.de [77.21.132.210]) by
 mail.your-server.de (Horde Framework) with HTTPS; Fri, 02 Jul 2021 18:07:51
 +0200
Date:   Fri, 02 Jul 2021 18:07:51 +0200
Message-ID: <20210702180751.Horde.xzhWI6XTdaZk0z3VkOQvQEv@mail.your-server.de>
From:   Matthias Treydte <mt@waldheinz.de>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>, stable@vger.kernel.org,
        netdev@vger.kernel.org, regressions@lists.linux.dev,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Subject: Re: [regression] UDP recv data corruption
References: <20210701124732.Horde.HT4urccbfqv0Nr1Aayuy0BM@mail.your-server.de>
 <38ddc0e8-ba27-279b-8b76-4062db6719c6@gmail.com>
 <CA+FuTSc3POcZo0En3JBqRwq2+eF645_Cs4U-4nBmTs9FvjoVkg@mail.gmail.com>
 <20210702143642.Horde.PFbG3LFNTZ3wp0TYiBRGsCM@mail.your-server.de>
 <6c6eee2832c658d689895aa9585fd30f54ab3ed9.camel@redhat.com>
 <d8061b19ec2a8123d7cf69dad03f1250a5b03220.camel@redhat.com>
 <20210702172345.Horde.VhYvsDcOcRfOxOFrUo9F1Ge@mail.your-server.de>
 <54cd08089682aa14cc43236b0799ebf8424a23c5.camel@redhat.com>
In-Reply-To: <54cd08089682aa14cc43236b0799ebf8424a23c5.camel@redhat.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-Authenticated-Sender: mt@waldheinz.de
X-Virus-Scanned: Clear (ClamAV 0.103.2/26219/Fri Jul  2 13:06:52 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Quoting Paolo Abeni <pabeni@redhat.com>:

> Would be great instead if you could have a spin to the proposed variant
> above - not stritly needed, I'm really asking for a few extra miles
> here ;)

Although this variant lacks the "else", to my surprise I have to admit  
that it works just as well. :-)


It was a pleasure and thanks for your work,
-Matthias


