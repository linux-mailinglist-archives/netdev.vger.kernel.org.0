Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF78D6C07F
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 19:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387584AbfGQRjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 13:39:19 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35278 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfGQRjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 13:39:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id s1so5193655pgr.2;
        Wed, 17 Jul 2019 10:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IstB0xucSwM7T/MFuvA5J+w9A4fMzt9m26wBf0MXApg=;
        b=mFJ9f+jZkf5DDQCeNejt8Xk5z4/PCEW/LlJFc29m1vJvwV9FFaOpfsenEVgg0C/ZYq
         rflcwoaqrf87y+AVg3HuAwf1hdL9pyWOVKZ9OeWEj7ycEirniG0KIlVSFKjWeYzPHi7n
         sEqG+daFatFOQlb84j4ftjp+ONaViw9ggdVlTj+DOVc6uWZMQhEbwd8GXCOhmSkiaD67
         dXjXKnKkZPVFgH2ZRiPpDsNxJoWOjAqjJ6llLtOUXHcfnQChPZljVKzaqKfL5J0jw+Be
         Sr/mrjkE6f+bkblLJKa3mzBZ1USybMHCoJ9qelmFE26ryqgQg06UdyJ1R+CiZeJBpAQq
         dRsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IstB0xucSwM7T/MFuvA5J+w9A4fMzt9m26wBf0MXApg=;
        b=sCRaeX+bWtupXb+eI5TCf0v+KerY9Kf1H1/12Hvl1ZXMKgnOKQzPeDZhSjgOLz+tKU
         5n/oknqoRlMTtfLC8b8/ee1698aJ/X48ULRfkac5RjfLEMqw2dJWWJVkgNhHCWhWZ70v
         uNV5f5pGUUXnthGM+DjaNUEtnziskZWKf5Z+wanKf6wQ8yPR+TgRVolZN+Eg23gOPGHn
         h3bTc+n/6CIAUhLh1Q9ZANg86Ii4hrV2deG+GGFCduUhkVx27yOcjD2DhEHU4pUbiyf/
         q35mlytDh3c3hwGMRXPjihN/hh+N8h62iHF2KgijGyL7Nuc9q8GmjXBqpNh6PX42hXir
         SgwQ==
X-Gm-Message-State: APjAAAWAbS4swXoBI6KFBkC5JTN5u8A7xtg4vNRDYrrlcoLP5RAqquXa
        R6RiJxT2JjLFPUlaqZCwW5I=
X-Google-Smtp-Source: APXvYqxBIDxoLHjzKefTAp2OwW2Bbj+ROwdbqFWb44H3vww/GnnPweMXdW6XRvV0dHZ9a8O+we6DxA==
X-Received: by 2002:a63:ec03:: with SMTP id j3mr15587028pgh.325.1563385158634;
        Wed, 17 Jul 2019 10:39:18 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id c26sm23794923pfr.172.2019.07.17.10.39.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 10:39:17 -0700 (PDT)
Date:   Wed, 17 Jul 2019 10:39:15 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 0/5] PTP: add support for Intel's TGPIO controller
Message-ID: <20190717173915.GE1464@localhost>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
 <20190716164123.GB2125@localhost>
 <87ef2p2lvc.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ef2p2lvc.fsf@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 09:52:55AM +0300, Felipe Balbi wrote:
> 
> It's just a pin, like a GPIO. So it would be a PCB trace, flat flex,
> copper wire... Anything, really.

Cool.  Are there any Intel CPUs available that have this feature?

Thanks,
Richard
