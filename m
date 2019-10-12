Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD947D519A
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 20:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbfJLSYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 14:24:13 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35404 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728636AbfJLSYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 14:24:12 -0400
Received: by mail-pg1-f195.google.com with SMTP id p30so7668094pgl.2
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 11:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6QaCuB8+ewa1hushkq9gzE3hzCX5Oi/rv+NRbA2RpEc=;
        b=rza6HFcHty6NQZGFhQDs/nk9cAFjOUjkvRvnhUyu3rS0WbRKGWyBCe274zCKZPFWTl
         edSjOlptEh4ZIsEpN+5C8A/jUV2TKfMBsup6JOodPc1YhtQc22lqShSFBv+9BLW6/ae4
         wcdcEfzU/dcuH+8fT/9g10GJjVJWz8smDRUAZ4P7UwEhTVkY0vuUbu7v+N7Lr8cx54nX
         uHQde7QjKpcl+xmPkfRQckJIczKHYh7zDQDbZ1MUY5x0/2ZeKJXkWmoCwZwIyNZmTLOh
         qA11u8plkikjZIZzx4atYfo+YGnOebyap/4lmRqPc3BbzYtbO2zXlWQq71k96hN7nlsx
         eACg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6QaCuB8+ewa1hushkq9gzE3hzCX5Oi/rv+NRbA2RpEc=;
        b=qnZIO8eblKz5/bFFU2e4Tuw1uAzHig59birvp+kww6JF23r0vKrOZ5jgarav29Zzwg
         ras/ldan61B7taKJH6pMLC4sfeG4fiCt7dy+ly3AUtXFR6tqoErFWf7oHoliMAdebe1s
         aJmeddjk6f0DEphJ/iEa6frir0UDXRSupqp/vdQ0R3w+m0Gsw8jZBsGvAxVZKL/I+faf
         9d9TRk+HaNIcV9j4AXg4A62mp7/fYtg3vumqdp7ZqLxnhy0IK+QYSRl1LIoA9UF+tTo6
         dyReWpfjia++qtEEZKmIC+0V4ZK3ZZl/EkSb2Dbo5Om+NHxonawzy2SpczaoMrG4G4YQ
         O2rw==
X-Gm-Message-State: APjAAAWUq87yMwqyTo3QKfQ7gk6C9vMGbtWVedNLgYArhEUDZifBQsMi
        fKPjdzvcupkiE6WvLunmVUY=
X-Google-Smtp-Source: APXvYqzcZO+iZEH6yEmVzubjeRTVxudnumFJRFmufyWgxWB6X5zXUdI2ZNg2O3RHNKhtkExqPqt2yA==
X-Received: by 2002:a17:90a:9416:: with SMTP id r22mr25439134pjo.20.1570904652089;
        Sat, 12 Oct 2019 11:24:12 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j128sm13686611pfg.51.2019.10.12.11.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 11:24:11 -0700 (PDT)
Date:   Sat, 12 Oct 2019 11:24:09 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org,
        Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Brandon Streiff <brandon.streiff@ni.com>
Subject: Re: [net-next v3 3/7] mv88e6xxx: reject unsupported external
 timestamp flags
Message-ID: <20191012182409.GD3165@localhost>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
 <20190926181109.4871-4-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926181109.4871-4-jacob.e.keller@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 11:11:05AM -0700, Jacob Keller wrote:
> Fix the mv88e6xxx PTP support to explicitly reject any future flags that
> get added to the external timestamp request ioctl.
> 
> In order to maintain currently functioning code, this patch accepts all
> three current flags. This is because the PTP_RISING_EDGE and
> PTP_FALLING_EDGE flags have unclear semantics

For the record, the semantics are (or should be):

  flags                                                 Meaning                   
  ----------------------------------------------------  -------------------------- 
  PTP_ENABLE_FEATURE                                    invalid                   
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE                    Time stamp rising edge
  PTP_ENABLE_FEATURE|PTP_FALLING_EDGE                   Time stamp falling edge
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE|PTP_FALLING_EDGE   Time stamp both edges   

> and each driver seems to
> have interpreted them slightly differently.

This driver has:

  flags                                                 Meaning                   
  ----------------------------------------------------  -------------------------- 
  PTP_ENABLE_FEATURE                                    Time stamp falling edge
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE                    Time stamp rising edge
  PTP_ENABLE_FEATURE|PTP_FALLING_EDGE                   Time stamp falling edge
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE|PTP_FALLING_EDGE   Time stamp rising edge
 
> Cc: Brandon Streiff <brandon.streiff@ni.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Richard Cochran <richardcochran@gmail.com>
