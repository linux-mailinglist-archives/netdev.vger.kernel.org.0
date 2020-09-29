Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D6027BC42
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 06:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgI2E7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 00:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgI2E7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 00:59:16 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2616AC061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 21:59:15 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id g4so3779852wrs.5
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 21:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y04EqMVFkBzcj+7faiDnptPG2EPf5DBzCvgB7F8ZLVk=;
        b=XTjjO+ZRKyufsDE4gV5oFHDCRXkke0BIVkzB6rY+Yu74djsAQy/oYArlxMNDh3eOwA
         HN7AYFGH3BazOSzZdVI0utcVmHHAVQL08Taq+aqlSHRwEyQDu76gxfqEgiAapCZ3Eo36
         uK76aE7VmOHFrbqw6iY0VQKtGEVbk7/hCEX3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=Y04EqMVFkBzcj+7faiDnptPG2EPf5DBzCvgB7F8ZLVk=;
        b=mkFHCxzrFhOv7x/LKMh8mftAD9J4E7VIKV9cr4klKcvG+2yU6ubOhhCTQvyihR9SzR
         VLgLZVWHN6iIJLqJntNrAHkxTJShIGduMVN3SiyOc6770szUGRMPY8GgUP3yCJlC4/KL
         KDrN7IKJw6DW5Efus24T/Cw1bXmghCttLfGEuaOLoRdlClRYeLoRzZEeFGA2Dh7QflkS
         vucxfRDMJlA5bj3afF5FRYWN7aHab4b3ybNiR8Io2RE958xs5/QiWHt+uRy25kiSt7J5
         b/HPEn7VDuuAVrwTI2Pe6VjFKKMAGYplozwpShd3yXztEW3R+HACG8QTA8Z0NQxvTkX+
         YtKg==
X-Gm-Message-State: AOAM530clpf1/jeHVzTtHXMljMirIzfmw7THklbq69VW3Pukzmh4GYK5
        5YanrkB4vpmxDJIJixJi6hpd7FO0ZwBSkQ==
X-Google-Smtp-Source: ABdhPJxOJlZ1cmJvb9fe9swzHMZBB11w2EiwtoyIwtTjc2EEkee/A/BegTXUhNHkEAJMnvXdQl4E7w==
X-Received: by 2002:adf:e74d:: with SMTP id c13mr1832099wrn.45.1601355553776;
        Mon, 28 Sep 2020 21:59:13 -0700 (PDT)
Received: from carbon ([94.26.108.4])
        by smtp.gmail.com with ESMTPSA id p3sm3506347wmm.40.2020.09.28.21.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 21:59:13 -0700 (PDT)
Date:   Tue, 29 Sep 2020 07:59:11 +0300
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     David Miller <davem@davemloft.net>
Cc:     gregKH@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RESEND v3 0/2] Use the new usb control message API.
Message-ID: <20200929045911.GA4393@carbon>
Mail-Followup-To: David Miller <davem@davemloft.net>,
        gregKH@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200923134348.23862-9-oneukum@suse.com>
 <20200927124909.16380-1-petko.manolov@konsulko.com>
 <20200928.160058.501175525907482710.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928.160058.501175525907482710.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-09-28 16:00:58, David Miller wrote:
> From: Petko Manolov <petko.manolov@konsulko.com> Date: Sun, 27 Sep 2020 
> 15:49:07 +0300
> 
> > Re-sending these, now CC-ing the folks at linux-netdev.
> 
> I can't apply these since the helpers do not exist in the networking tree.

Right, Greg was only asking for ack (or nack) from your side.


cheers,
Petko
