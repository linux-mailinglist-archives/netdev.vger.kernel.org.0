Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3DE727A0
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 07:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfGXF4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 01:56:47 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43012 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfGXF4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 01:56:47 -0400
Received: by mail-io1-f68.google.com with SMTP id k20so87005050ios.10;
        Tue, 23 Jul 2019 22:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=E6VQtWP2Qork1ITHffxNTt9vOJoeld9a+/tl+suTeZs=;
        b=QUdjUPQ6JMmP0H3wsWzvspkk/2zFluSDgd7egZhjHKPWA9mwGimY+3zfCDG3YjNPjn
         ZaFNic6ggJSNuSdYItOHrgMq7rLWr83NAo531nOApeTlFyFPbY0bQ/lshQiHa4wUIRbj
         8Adtv9CVaZh744oEUjQMCuJZbTyo3Q5IqMHJNgdHD7O3YPFg/yXmej46kH3IkJAatg3f
         ZA3EHIRMSUhREgbOq4IGhPG9av9I/srQ7wry2B4ykFnoOWld8MH4vRfpdPpsfa34vipE
         stlyHTSnalTq1vXoi+2sW5qmEhozDTX91NTX1/Bc2stDuMcY9NPJeeQO9LMXVolJjndP
         7j1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=E6VQtWP2Qork1ITHffxNTt9vOJoeld9a+/tl+suTeZs=;
        b=EllVBld73IoZlFWXcDs5t1ILxZRvaCddPFypIub7axXFLX0jg2XTGMCtJdDEkxP8BX
         U4qolhGbtpc1mEieI4AJ1SNHK1HdHpB+iWS8fmvI0jSGxf37FUkFK1quba6IJWT/UbzI
         Nx+TJAU+ACFh9rvM+zWahQiOE0dZgHHvB4dy5llv+WQBil3zaX+AvKIpRYdqALS2Exbq
         PO3HM1zFlNTbK7HvAV9C5g1CX0+S4tCiE0J6h4JGa6XCDJM+6D51UtnvQIv3y/3hC0tb
         RYREEb/FhTRXerF4XEyh1h510IPqEuocfDzLKoIG5j9EJWQ4wrEvD14jcfslOZGRUKwa
         FgeQ==
X-Gm-Message-State: APjAAAWiYClxLolXofdN79ekblWK8+yRkexEdLHI7IGmM8/4uEe1m3TY
        iT3Dj5OGnZSs5VzPyALe9CooD5/EtocrmA==
X-Google-Smtp-Source: APXvYqzqzNrT7CUSQvyikq1Qah+Ake+fp6s52iiY2yNkvNiZeFeFTRwwL5fFHe4b/PKVG6ewk1n4Dw==
X-Received: by 2002:a02:c6b8:: with SMTP id o24mr11826016jan.80.1563947806251;
        Tue, 23 Jul 2019 22:56:46 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id s10sm108747905iod.46.2019.07.23.22.56.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 22:56:45 -0700 (PDT)
Date:   Tue, 23 Jul 2019 23:56:44 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     iyappan@os.amperecomputing.com, keyur@os.amperecomputing.com,
        quan@os.amperecomputing.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bjorn@helgaas.com,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v2] drivers: net: xgene: Remove acpi_has_method() calls
Message-ID: <20190724055644.GA103525@JATN>
References: <20190722030401.69563-1-skunberg.kelsey@gmail.com>
 <20190723185811.8548-1-skunberg.kelsey@gmail.com>
 <20190723.140646.505566792140054611.davem@davemloft.net>
 <20190723.140739.379654507424022463.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723.140739.379654507424022463.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 02:07:39PM -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Tue, 23 Jul 2019 14:06:46 -0700 (PDT)
> 
> > From: Kelsey Skunberg <skunberg.kelsey@gmail.com>
> > Date: Tue, 23 Jul 2019 12:58:11 -0600
> > 
> >> acpi_evaluate_object will already return an error if the needed method
> >> does not exist. Remove unnecessary acpi_has_method() calls and check the
> >> returned acpi_status for failure instead.
> >> 
> >> Signed-off-by: Kelsey Skunberg <skunberg.kelsey@gmail.com>
> >> ---
> >> Changes in v2:
> >> 	- Fixed white space warnings and errors
> > 
> > Applied to net-next.
> 
> Wow did you even build test this?   Reverted...
>
This patch has definitely been a mess, so thank you for your time and
sticking with me here. I thought my build tests included these files,
though discovered they did not. Since submitting v2, I was able to reproduce the
same errors you listed and corrected the problem in v3.

I also realized my .git/post-commit file needed to be fixed, so the white
space problem in v1 should also not be a problem in the future.

Please let me know if you notice anything else I can improve on. I will
learn from my mistakes and really appreciate advice. Thank you again, David.

Best Regards,
Kelsey

