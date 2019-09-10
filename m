Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D9CAEEC3
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 17:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436508AbfIJPo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 11:44:56 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35477 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfIJPo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 11:44:56 -0400
Received: by mail-pf1-f193.google.com with SMTP id 205so11763212pfw.2;
        Tue, 10 Sep 2019 08:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=m63hw1cs8JEboshBAGEaMeLbl7XzJEKKBEYO3wrpjaI=;
        b=kq6eaah8+m6F18GfdV3XcEdwfQpiX+5ZJMezDnp2FBv2dUX6PeRDkg7ovLEztgIHKo
         eeyjRSDV1yoViFEibX7LnpZVrcyVlkFrzF7ej8S4Bk4B5tVG4VhJeES/wBlWX3XUW04c
         //sHuqxm2vtx3hU2s9ktsvkZzDl0QGddQbZe/7nCS0SG2QtgubWVVB27TNu5thGuBGUE
         vbgaq9IBjZ/e87w67LMiIEKqfuFy3xvM+jFnuynJ1Ev5fliVXnmHuroW4rZVy/AHZb9f
         KoQTCCvN/EXdNVLqE1tAQygH532nLPZ6NRHsVk3X3PYRATF8GKVNhzARK+Kq435GWLzp
         ZbfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=m63hw1cs8JEboshBAGEaMeLbl7XzJEKKBEYO3wrpjaI=;
        b=ncNzIDBAuFmOLqA3rPYDVbaxdvkqOfxr+P8DQ9cn1td8rxffsAfki2+bvq3kCVZKDA
         wiLWM6Cjf/zVD1SSbXK51Cq+XLR2VGyyWF3CJ5/6tN8unr5v9pEY7OJq0xs6TPsPms4f
         qBhqZL95J8bqaYvVlcY+n32YV4ak9TYa8CS3t72LYUT5eRiYGRUH38Q1bKT/e74WA+bA
         ix4zYcZR7/qH/lS6iXU8OlMIkxzS81nywY0KbZHAndndqbR7YxAip7yA379pUpZgY2sQ
         71OesntgRe7QrziOhvx2nyDxBL2C5ayACEiqnVSOgxu9QRZ6ZlVqFbpZl1BNvF7yUoeS
         v8Sw==
X-Gm-Message-State: APjAAAXOsoUxiGbOhHSAgW89Gt4vre9TsY0RM2upIk6M5v3OUjnAvb8o
        98nE2XgnmGt0xM9h3X37TlW5PBqo
X-Google-Smtp-Source: APXvYqzV1cJeUMekbuzzKB1C1mNg0F0I/CBYw9iROFj0oksAoAudc6Y047duVySUEjBnmgRBOFdOeQ==
X-Received: by 2002:a63:7887:: with SMTP id t129mr28839763pgc.309.1568130295689;
        Tue, 10 Sep 2019 08:44:55 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id 127sm34662989pfy.56.2019.09.10.08.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 08:44:54 -0700 (PDT)
Date:   Tue, 10 Sep 2019 08:44:52 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] PTP: introduce new versions of IOCTLs
Message-ID: <20190910154452.GB4016@localhost>
References: <20190909075940.12843-1-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909075940.12843-1-felipe.balbi@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 09, 2019 at 10:59:39AM +0300, Felipe Balbi wrote:

>  	case PTP_PEROUT_REQUEST:
> +	case PTP_PEROUT_REQUEST2:

...

> +		if (((req.perout.flags & ~PTP_PEROUT_VALID_FLAGS) ||
> +			req.perout.rsv[0] || req.perout.rsv[1] ||
> +			req.perout.rsv[2] || req.perout.rsv[3]) &&
> +			cmd == PTP_PEROUT_REQUEST2) {
> +			err = -EINVAL;
> +			break;

...

> +/*
> + * Bits of the ptp_perout_request.flags field:
> + */
> +#define PTP_PEROUT_VALID_FLAGS (~0)

I think you meant (0) here, or I am confused...

Thanks,
Richard
