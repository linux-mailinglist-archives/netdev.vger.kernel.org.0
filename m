Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEE82BE95
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 07:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfE1FVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 01:21:52 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:44522 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfE1FVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 01:21:52 -0400
Received: by mail-pg1-f181.google.com with SMTP id n2so10211333pgp.11;
        Mon, 27 May 2019 22:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2OXaxWu8+tr36kStJmbI15SOpfldjJuZjUwe+BtozsM=;
        b=dN8TSAYUhgZW9Rp2P9t3Mfcuu3C+7jocGLBTFCzjndPSgHnr3sI0zznbO0ItYbAs/T
         OqUHfMOnRqLWvd0+Hujn/teZtNAOWj6tahMgjsH15YYInm0bcvWTopZbP0B/V66PHly8
         dGWNvtzuAJBCS3N8GWGXqCbJXkHzaZ463irmurxxLk7vLVRA+T1mrwZBroDVRdfz4eCv
         zamDhxnA4F5e9MRO1wFzj45onEIFsbCbOKiQ1zvM5z+v+QDEiD+rWPQeTq2vum4pYDX7
         BDc24p9bKBKBH0OA6R9dgnxCcL13/GvchOKmPkRnw1JJnegU7wNovZmivimki3XM+EJd
         4m7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2OXaxWu8+tr36kStJmbI15SOpfldjJuZjUwe+BtozsM=;
        b=EDz01Vcpu0STODIh0e+fRJ4DXCIRrv7Vk5bUJQ90DCNfGqXCzXir+AwDrkfCnTtpvo
         TuuPtH64DYG201YI/eN+DpO22fJmGFkMjtqTM1fsyJ7gJQfLwYldCFouI9pKfG7Wryzg
         uL4L6+qou7jvIWRlDQpjcBHjMr0Ry+zeTARi4jQGSzmx3jtmXQiySbMUOFm5+7YpTeOr
         bZC3eJFzY2gg69FWb+0xsPYCA0KfofC0vU1sE7qN/pUnrDfLL971/5LzqovLxQXeqOV2
         4oNP4MdNG4cyHObYwdQLw49Ovupt3/KqPxmge8lmOGZdAIDDbx1+6ZSM/EZLmRHiuGS8
         TjPA==
X-Gm-Message-State: APjAAAVXhH3aeRYNjo67rRhvNmvL8zrQEh/h2yg3aTnRiNq8HzYt2I+H
        TIyqJC7PsQyWf1cl+g3eI0A=
X-Google-Smtp-Source: APXvYqzZdFJ/ujoE7JbbVH/u2eYkthKnmPZmZs5jZB7zx8baa9bIYnULDsp/gUVvph0rfpl/Et1N9w==
X-Received: by 2002:a17:90a:fa08:: with SMTP id cm8mr3225981pjb.115.1559020911439;
        Mon, 27 May 2019 22:21:51 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id w1sm3390859pgh.9.2019.05.27.22.21.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 22:21:50 -0700 (PDT)
Date:   Mon, 27 May 2019 22:21:48 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH V3 net-next 5/6] net: mdio: of: Register discovered MII
 time stampers.
Message-ID: <20190528052148.euhxk75brsiwzixo@localhost>
References: <20190521224723.6116-6-richardcochran@gmail.com>
 <20190522012227.GA734@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522012227.GA734@lunn.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 03:22:27AM +0200, Andrew Lunn wrote:
> Shouldn't unregister_mii_timestamper() be called on error?

Yes.

Thanks,
Richard
