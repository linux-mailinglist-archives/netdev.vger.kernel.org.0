Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1B4C1EB5
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 12:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730662AbfI3KKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 06:10:03 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55643 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730105AbfI3KKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 06:10:03 -0400
Received: by mail-wm1-f68.google.com with SMTP id a6so12667597wma.5
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 03:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q3OurbnQGmY4mhyhHMF38I2zLhdGs/aiZyCkpnfeb2Q=;
        b=nz39gKZubxWCMMv8VFISEO5dpKISgCl7N9tEVOkKwjfYFm/E4wTFPd2nGHLjo0SvoG
         Wep4wKED4KzOz0pSKrMc+J6IF1DZYDovk2amtHo24xQfboOFYgl1dcI+kvmb0wcMJWbh
         QHVSIXJ78WI+g+SWuPCbsx1SutlkeeM0V67YBB44ZSLfIguetZoAKys60NUIogiWTGqr
         xvGDrbAbXBjU6qQVQYTs74s/xWHrYZa6NBGZ3kNGFQoinDZ1bIz1YuynuPiUzbR9pDMG
         V39JeLCWgQtTqSNx7FN1cnbheUSKzD84rD6iJjinruItfcPqj/4MsUFb3WunwHq27HBc
         1c6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Q3OurbnQGmY4mhyhHMF38I2zLhdGs/aiZyCkpnfeb2Q=;
        b=pWPZhkhULULdJVYqV2lyFh+NuwdQFiZ0WPIa5eU8cp8zViQIlVxprYRtOEk0oMV+ZL
         qbFXyeobqqHoW1evnVm522RuFZ1bCSQ6GjI+A571HCOUgWZLl8DgTGR3h9qtUBtCM67V
         2qXjDO9xkfFhK+AqNXfiWhhLa1r/cj+Mkv6Tz881+hQal2Bqf1Et5ZsWLP3A6MbTeu2W
         /5OqKeSHqIuYH6X305V1GIHIvKKpp4zz3uQIfiAPAQA8NTr1TQmhQDQ8ZRH3EkHzTo/A
         0Vhec5ueVLQ/JIOISTPIEDeTUk0GCgiPBSMwSIVhskz62GTksW6xMat9z6ZT68GPW5g/
         VWEQ==
X-Gm-Message-State: APjAAAVnBk7r6muFn4Adz+JYA+4m2PrVkwUkXXos047+vgjLujVTy6SW
        ATscZWuabjaiUKLRPU8VKXgL+V55GsI=
X-Google-Smtp-Source: APXvYqwgWi1uQI/BcGoJ+HsYkT8xtF0hny2NOwN4tvAGWo4VFccQEsTNq8wdYDShvCJuVHFVtekhBw==
X-Received: by 2002:a7b:ce0a:: with SMTP id m10mr16559610wmc.121.1569838199590;
        Mon, 30 Sep 2019 03:09:59 -0700 (PDT)
Received: from localhost (ip-89-177-132-96.net.upcbroadband.cz. [89.177.132.96])
        by smtp.gmail.com with ESMTPSA id l10sm16780799wrh.20.2019.09.30.03.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 03:09:59 -0700 (PDT)
Date:   Mon, 30 Sep 2019 12:09:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 1/2] ip: add support for alternative name
 addition/deletion/list
Message-ID: <20190930100958.GC2211@nanopsycho>
References: <20190930094820.11281-1-jiri@resnulli.us>
 <20190930095903.11851-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930095903.11851-1-jiri@resnulli.us>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In subject of this and the next one should be iproute2-next, of course.
