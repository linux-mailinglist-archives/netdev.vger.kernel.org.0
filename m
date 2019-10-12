Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6F6D519F
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 20:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbfJLSbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 14:31:13 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:40768 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728162AbfJLSbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 14:31:12 -0400
Received: by mail-pl1-f180.google.com with SMTP id d22so6019371pll.7
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 11:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=137/MKYT1FNFFjoBRY1hvbdAVT4qFoo7IGV1ZmT7Z30=;
        b=p512EEDiOKJEn1zLUYoyChNEx3ukY0XhFXn7e+dx+uT/79pKNgz1jJf1dpAb5GpAQl
         o6Md2fy4vIAyXAnvnmyoSZ7T1x/9deHRNrfBYzJNJRoUIimgYMBu9+h6RcIlvBvGRIJ4
         99IK3YolNZ3Vry9RryIXS7X2srRrDoEwcNTuzS8/uSUre8WNLKtbx3IAfov2hSDCxdDB
         FnaWpS2zFgKFehYIXspNrmQjLoJd83re1UjBqkObq8kQWMssh99wWAmDq2edBM0hbnJI
         8yb8CV1RlvOE3QkUEOG5mMFe449maHefEIYBn6H1sV1vfEA4WIKuEvaVsYY4jX4yirtl
         JeWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=137/MKYT1FNFFjoBRY1hvbdAVT4qFoo7IGV1ZmT7Z30=;
        b=IFBJDvD0CakNITkC3AJezv2M8b5hHQ06xeZQ9epg+zIvaY3w4+SJEJBD1/w3XLblg2
         vcvfWYOtyblne9nk+nijaWQPxjA3aiZa8d42NYzNMwzSLbS0hbs8zKRaPMbe8vGpx4tf
         5TN+Z9U9R+VXfZIrJhFl/LIFxiXZgR+B0snh0MIt2NCVSwaenzSg6YD5QIRACYZO5L2d
         OdhA1dmTDPDl5Po8HLc13eR/E6Xa94QTHb/nH38QDw2xK5+FcXAdkSAWrZa1a2IdZDq/
         myEHuyBDkNGs182p6kXgA6Gk9qnrTkjQptOdg+gvy6gXWkpdCUlNqZF9+WQb/1LsfeAk
         q/Rg==
X-Gm-Message-State: APjAAAVPJcUkiYfzdozSHr7LBSha72Te/T5SAMN+17qYtsvqg/7llZCo
        /fEE6L5hlkrhfqrZx3yoLrc=
X-Google-Smtp-Source: APXvYqzDqsXqHaKCHT3zjCUjLMxQjKFRCWgXFnj8igbBOEjJWqCmR9uCjD+AHpr/2SHo7yKtwAt8DQ==
X-Received: by 2002:a17:902:7b96:: with SMTP id w22mr21558132pll.40.1570905072120;
        Sat, 12 Oct 2019 11:31:12 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id m12sm16885687pff.66.2019.10.12.11.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 11:31:11 -0700 (PDT)
Date:   Sat, 12 Oct 2019 11:31:09 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org,
        Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [net-next v3 5/7] igb: reject unsupported external timestamp
 flags
Message-ID: <20191012183109.GF3165@localhost>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
 <20190926181109.4871-6-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926181109.4871-6-jacob.e.keller@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 11:11:07AM -0700, Jacob Keller wrote:
> Fix the igb PTP support to explicitly reject any future flags that
> get added to the external timestamp request ioctl.
> 
> In order to maintain currently functioning code, this patch accepts all
> three current flags. This is because the PTP_RISING_EDGE and
> PTP_FALLING_EDGE flags have unclear semantics and each driver seems to
> have interpreted them slightly differently.

This HW always time stamps both edges:

  flags                                                 Meaning                   
  ----------------------------------------------------  -------------------------- 
  PTP_ENABLE_FEATURE                                    Time stamp both edges
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE                    Time stamp both edges
  PTP_ENABLE_FEATURE|PTP_FALLING_EDGE                   Time stamp both edges
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE|PTP_FALLING_EDGE   Time stamp both edges
 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Richard Cochran <richardcochran@gmail.com>
