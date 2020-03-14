Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB5A818531F
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 01:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgCNAF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 20:05:26 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39293 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgCNAFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 20:05:25 -0400
Received: by mail-pj1-f67.google.com with SMTP id d8so5217768pje.4
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 17:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XMbsIM64mSqh05JrNCssnMJdLyFSzyI+BFOw0GkSMUw=;
        b=N8sEhkg8OD5Crs0Brz2CKkPWnZ0eeqdPahnd1a/gGHpOic4OtduLsFeG3gqAajmnxo
         yTM6E/oagbTbE+Jaq2YK3kn4qsVnin8ITXfBduGQPTCkapgvcxsc+JMJKkSCC+jioSwB
         Xfc9Kow9XjvxYhd+bjbGVs2ziweFLEYZ9/ghs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XMbsIM64mSqh05JrNCssnMJdLyFSzyI+BFOw0GkSMUw=;
        b=rKF3SSzal6a5umX+AINK/DOWVSxZJKYC5QqpOjEbh+lS3Suq3XarAlpnP44l/opN/g
         KreBOZSqBK3jIIMSzgjK5ZM7AqIJ7ZtDwM7OQxaJ3cfYqAHVvmC6cOt6hvgKPJrGspEK
         Wq/6P1ARKoNDe25BZXEpV8ZAAHyLZ7koaaxWbx/RB4OyUP77MdvWwk4aFSD1i6EuTSpZ
         /QM5ULJF/8tc4Eq/nfjN9EwhgCvTPoSo+bJN8D/CTzTIizFS+E46wWUXKxoi8gQqvs/P
         u42YWMn7b+w1/D+O1AUUcqZXd/bdStWxwVuRV3UpL4oMm1sm+7BvZrOCCagiAroaUoh1
         hDdg==
X-Gm-Message-State: ANhLgQ30TccSRL1Uu1n5SNR5Mkh/Y/dpkZqZyNAzavk68N80M5sJkQNM
        uqN9BDzB2lhSHEnirzYTZeKcJA==
X-Google-Smtp-Source: ADFU+vu72CrRKxiU4iI0BkuqzGvtp4WpzvnmPuk88nJZHE9CiRgLsPEU2Usf8IB4MV5AjKGf740udA==
X-Received: by 2002:a17:90a:37c6:: with SMTP id v64mr12593867pjb.20.1584144324743;
        Fri, 13 Mar 2020 17:05:24 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i6sm19548184pfe.62.2020.03.13.17.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 17:05:23 -0700 (PDT)
Date:   Fri, 13 Mar 2020 17:05:22 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     shuah@kernel.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 4/5] kselftest: add fixture parameters
Message-ID: <202003131705.F6D0FD73@keescook>
References: <20200313031752.2332565-1-kuba@kernel.org>
 <20200313031752.2332565-5-kuba@kernel.org>
 <202003131628.77119E4F4E@keescook>
 <20200313165202.37d921cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313165202.37d921cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 04:52:02PM -0700, Jakub Kicinski wrote:
> On Fri, 13 Mar 2020 16:31:25 -0700 Kees Cook wrote:
> > > @@ -326,7 +387,8 @@
> > >  	} \
> > >  	static void fixture_name##_##test_name( \
> > >  		struct __test_metadata __attribute__((unused)) *_metadata, \
> > > -		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
> > > +		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self, \
> > > +		const FIXTURE_PARAMS(fixture_name) __attribute__((unused)) *params)  
> > 
> > Could this be done without expanding the function arguments? (i.e. can
> > the params just stay attached to the __test_metadata, perhaps having the
> > test runner adjust a new "current_param" variable to point to the
> > current param? Having everything attached to the single __test_metadata
> > makes a lot of things easier, IMO.
> 
> Sure! I felt a little awkward dereferencing _metadata in the test,
> so I followed the example of self. But I can change.
> 
> Can I add a macro like CURRENT_PARAM() that would implicitly use
> _metadata?

Yeah, that seems cleaner. Thanks! This is very cool. :)

-- 
Kees Cook
