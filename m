Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90D71257CD
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 20:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbfEUSw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 14:52:58 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45706 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727990AbfEUSw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 14:52:57 -0400
Received: by mail-pf1-f194.google.com with SMTP id s11so9505164pfm.12;
        Tue, 21 May 2019 11:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=zFfzCQm5vYmPTxj3YDGvmk4x2lGzmz6fEr37wIaaihs=;
        b=CVfGrzHJDM8iQTQjLbNHqZiW36/MRZKk6uVcUe3qo/5NTRtlVa1VC4tSERh3Jp6KLH
         IyhfKCdjKsDbdvagRatObBK8n71eBSPyNtsTc9sGnewSKPK0zd2T88nWvJrHAeeUaoi4
         9nbYdM5XDgq88ALH5AvGosmeafteRuxY9SNYwiNIfCrBj9jWSxF8mGIT0pku5Z1VsSwJ
         ZvgcP7YmKWUMQhjI2OYo3OdUGT9qFgavEsy+zvPFLKV6ILM+CcJYH8PGY6FVwrnaOCRG
         rhKNUGb7nj0fiwK4FMcZy/pomO16KJ3hOWXRUy4RXdscsxZjJLMp+VCOzguEUL3xAbV6
         EbPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=zFfzCQm5vYmPTxj3YDGvmk4x2lGzmz6fEr37wIaaihs=;
        b=LMj0f+bl7NrJ3ASLYK33znazLG+AhpbJgnamELj1OWy5o49fK42l0nD5vJv0p7t2eZ
         Fc1IJUl/0KG7VkNunFtBJVkhVjxPWL4v9tK4rHmD7JSGIwHxlFEgWblcG2vSEEwmtztA
         rzLpiTs2JC4v/MhkABZYBIshh5IXtmo0PL4TaDyfNadRnUmRBMFsiMzNEfSLr0GtGshe
         cN7PmXAorqQolSmyyiaLxvaHEKpdRcR56GA7QXMW3Q+kgiTmAguGE5yuzSBscBU/p7oC
         mA+1+J0ggjWqA5xGmXgMQB8CYlXbFdbibd26n241V6kGxntSet/vqYhJa188SJ4MVsRJ
         AfvA==
X-Gm-Message-State: APjAAAVWXMrz36mbuMbP3qMIUWrp5z+MU0AA02v4nKCjfMv3ezPdJ9wh
        gZpgtY7wmSgT4oJ+2t3nX08=
X-Google-Smtp-Source: APXvYqx41timVbIM6JdvlYYI5X7nI948bZFGXxSBw9utsd8rrQPX/l5X6qvgwhRtaoODo0lIWwKj4g==
X-Received: by 2002:a63:a55:: with SMTP id z21mr84618129pgk.440.1558464776851;
        Tue, 21 May 2019 11:52:56 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id v16sm5187591pfc.26.2019.05.21.11.52.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 11:52:55 -0700 (PDT)
Date:   Tue, 21 May 2019 11:52:53 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH V2 net-next 5/5] ptp: Add a driver for InES time stamping
 IP core.
Message-ID: <20190521185253.xxcvpx4dqd6htszj@localhost>
References: <20181007173823.21590-6-richardcochran@gmail.com>
 <20181012204256.GA16019@bogus>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181012204256.GA16019@bogus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 12, 2018 at 03:42:57PM -0500, Rob Herring wrote:
> On Sun, Oct 07, 2018 at 10:38:23AM -0700, Richard Cochran wrote:
> > +
> > +Required properties of the control node:
> > +
> > +- compatible:		"ines,ptp-ctrl"
> 
> ines is not registered vendor prefix. Should it be 'zhaw' instead?

I am preparing V3.  Can you explain what you mean by "registered
vendor prefix" please?

This IP Core comes from the ZHAW School of Engineering, Institute of
Embedded Systems (InES).

ZHAW stands for "Zürcher Hochschule für Angewandte Wissenschaften."

Thanks,
Richard
