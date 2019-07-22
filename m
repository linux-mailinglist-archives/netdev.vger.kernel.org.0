Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B96B7097E
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 21:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731878AbfGVTOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 15:14:15 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41409 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731466AbfGVTOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 15:14:14 -0400
Received: by mail-pl1-f196.google.com with SMTP id m9so19495138pls.8
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 12:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=O9BbPnmI+pHoI/NQDPXVHcO4RcOKDp2TZ+FeQcswyuI=;
        b=H4APkLXJRK/q7ukCstH9qo49f7JrC1BR5KVMbG+8RY+d6vqMcg1vyfHihn4f1tfloM
         WuNKUwAJlufYR0Qn0fAu83Z8xx1H7ZanZPEpW13uQ6ahzZm+rU5ixiOOUe+MRjd5xa+l
         kzekOMj36vdf9V0CWtNVbnu6PnNGDIpzEkEiU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=O9BbPnmI+pHoI/NQDPXVHcO4RcOKDp2TZ+FeQcswyuI=;
        b=O0KTANjSv1JPi+BRiOKlbCs33z4l7aVQ3wyZUbfSF7UTKyTIWnq4yrsXC/slDko0oF
         XGqoBnOUEpvO7pkzLkyuZL6KxBzXVTqtEStJAnClwnVhDrlhiZXk/a63XutWBQHh+CcT
         gplOs2qGYa8wyGZ70FyyVtiyzWj4IJsDxPqqKW59JA7O0TldjdBanW8oaa6T/NkuD1Rr
         JKHUcQ30jE/poGVQ9A3f1EwGEGieMsjFun5NtzUCK0eN8lNCk0X4Q7GSoHs17/12v4Gk
         T88UP8tmNYkQGXSXYc8hCSpJAmdHykwKQPARC1nFQhhR36z1ngYrzXL5zeWb0rVrR4w3
         wbDQ==
X-Gm-Message-State: APjAAAXLT6fL/h5lA5icMgB8stP++qgFbZZx1lLdrAsecqS0sOyeGPnm
        2k5HRw6G9qTJ+Fz3x5gqyG7KXw==
X-Google-Smtp-Source: APXvYqye8KADnaKfIO2xcVLE1cwxtty5tPY77LPyY5ryPz/+MASHRSWvD9J4mt/y+V4sUlO4fxKuxg==
X-Received: by 2002:a17:902:aa5:: with SMTP id 34mr79416847plp.166.1563822854072;
        Mon, 22 Jul 2019 12:14:14 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id t96sm36367885pjb.1.2019.07.22.12.14.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 12:14:13 -0700 (PDT)
Date:   Mon, 22 Jul 2019 12:14:11 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 6/7] dt-bindings: net: realtek: Add property to
 configure LED mode
Message-ID: <20190722191411.GW250418@google.com>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-6-mka@chromium.org>
 <e8fe7baf-e4e0-c713-7b93-07a3859c33c6@gmail.com>
 <20190703232331.GL250418@google.com>
 <CAL_JsqL_AU+JV0c2mNbXiPh2pvfYbPbLV-2PHHX0hC3vUH4QWg@mail.gmail.com>
 <20190722171418.GV250418@google.com>
 <20190722190133.GF8972@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190722190133.GF8972@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, Jul 22, 2019 at 09:01:33PM +0200, Andrew Lunn wrote:
> On Mon, Jul 22, 2019 at 10:14:18AM -0700, Matthias Kaehlcke wrote:
> > I'm working on a generic binding.
> > 
> > I wonder what is the best process for reviewing/landing it, I'm
> > doubting between two options:
> > 
> > a) only post the binding doc and the generic PHY code that reads
> >    the configuration from the DT. Post Realtek patches once
> >    the binding/generic code has been acked.
> > 
> >    pros: no churn from Realtek specific patches
> >    cons: initially no (real) user of the new binding
> > 
> > b) post generic and Realtek changes together
> > 
> >    pros: the binding has a user initially
> >    cons: churn from Realtek specific patches
> > 
> > I can do either, depending on what maintainers/reviewers prefer. I'm
> > slightly inclined towards a)
> 
> Hi Matthias
> 
> It is normal to include one user of any generic API which is added,
> just to make is clear how an API should be used.

as of now it isn't even an API, the phy_device populates a new array
in its struct with the values from the DT. PHY drivers access the
array directly. Is it still preferable to post everything together?

(maybe I'm too concerned about 'noise' from the driver patches while
 we are figuring out what exactly the binding should be).

Thanks

Matthias
