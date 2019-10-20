Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78844DDCF1
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 07:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfJTFzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 01:55:03 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34106 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfJTFzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 01:55:02 -0400
Received: by mail-wm1-f68.google.com with SMTP id y135so12170642wmc.1
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 22:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6rbfmJtz4+oQR4OoiAumDR3YPy9qFTUhDGGllacxSDg=;
        b=iNWZFOOxNlyqRjqjrJvYCrIopGP/M+yJvli3U7yCaLMUobM79KX4UvKyYpDoFvnJfE
         s37Rmf6FAyLqYsZSU2FqAUPRi0KW29Io6I4izBlOxvC97Eq6potuy7jdGQRqOPlucVsn
         E7kKDgqnHEMaGKhMRADAkAYU44R2poKebRPz0uktohgQo31CgNET5UNJxkgZqb+pxJ9C
         OjiZleXnskP6IuRH/po3KlN5x1aSXtlkWWP5EOD6qHJXACG9tWizV2mjpH8PdKx0JSk8
         lGznROX1NKtYog0g1pBTwmhRgZgLXwRqkX4RykgQRHodn51rWW2BIxJ/Q2ZsN8YC7o9G
         75Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6rbfmJtz4+oQR4OoiAumDR3YPy9qFTUhDGGllacxSDg=;
        b=cmji0cY0ylLVpsPcYPYeNGM9/lsaCaOUTKXzbhpEhwDfTeSNtOA9J0C5qjeOXElSsA
         66F1pS04pZpqxHOzaE3SC8VUBmc5Asdq4bCaHR8ILrCsvLfk84CvvMb6kRJpPWTdmwyX
         x56ek2CfGUwrfCuykL7I4hEwyktSNgQUGmjkwBxzikj0KmHuSHLYWCJDtLTYXsAykjn3
         nGfy7gkKUrCdtKStQFFEf3V6jbiL9E/fF2fnsAE7XalOgWGgfq6eMHAW2ffg7lZrhoox
         9KFsiA9q1hu1zHN/7p+2xe8LuTuwaZsUf6BvyNDg+weXoLQDPCpc0b/0I3Gy0t1oCKTY
         iTXA==
X-Gm-Message-State: APjAAAWfotd+pZ/WxDhtfcuZwr6O3Bhm8GWjdfsouU4q3F1ZS9SI9I7N
        jaxZdarfBblYEgFZSvEs5HNYXg==
X-Google-Smtp-Source: APXvYqzxaubH6LdZ6mGyYU5S/J768aiQXsIJD75YlbMtNaOkVNDtfWKgp4GpmzSdzvQhR/K6YJvKiw==
X-Received: by 2002:a7b:c629:: with SMTP id p9mr14299056wmk.65.1571550900528;
        Sat, 19 Oct 2019 22:55:00 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id u1sm9666240wmc.38.2019.10.19.22.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 22:54:59 -0700 (PDT)
Date:   Sun, 20 Oct 2019 07:54:59 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v4 2/2] net: dsa: mv88e6xxx: Add devlink param
 for ATU hash algorithm.
Message-ID: <20191020055459.GO2185@nanopsycho>
References: <20191019185201.24980-1-andrew@lunn.ch>
 <20191019185201.24980-3-andrew@lunn.ch>
 <20191019191656.GL2185@nanopsycho>
 <20191019192750.GB25148@lunn.ch>
 <20191019210202.GN2185@nanopsycho>
 <20191019211234.GH25148@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191019211234.GH25148@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Oct 19, 2019 at 11:12:34PM CEST, andrew@lunn.ch wrote:
>> Could you please follow the rest of the existing params?
>
>Why are params special? Devlink resources can and do have upper case
>characters. So we get into inconsistencies within devlink,
>particularly if there is a link between a parameter and a resources.

Well, only for netdevsim. Spectrum*.c resources follow the same format.
I believe that the same format should apply on resources as well.


>
>And i will soon be adding a resource, and it will be upper case, since
>that is allowed. And it will be related to the ATU.
>
>     Andrew
>
>
