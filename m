Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 441FCDDB11
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 23:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfJSVCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 17:02:07 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40340 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbfJSVCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 17:02:06 -0400
Received: by mail-wr1-f66.google.com with SMTP id o28so9697533wro.7
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 14:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AVrUmUhOU9NG8giPbmZ+OQFPwWBxRcnAm3gvzplbY84=;
        b=vEcah3qiXBaPdsM8Yk/ac0d7qdV2437sAeeLXDP7uiWoQhoGRQGxD0IOFEAiQcs0gQ
         pZNHhzQuRB9JW5CPMznseErXdDsJccm3LgW4RIOq70tE1Z2JRZ0JzbXcNmfbP9pvTq1c
         l/Tht6mYU3KBxnbyxpRtzrNvaUZFOO3vpIxaW+QSOVIPw6ObN8/oTbN4BRccdMqTHRtn
         HHf5YPrbBrKtbZ3KPqF1L8WFjFAMUy9gAEpQoIE/lCHLRfsYhkO2S9lBRXM0MpnGPNXr
         MvHflykUHwZ+6XHlLRPOvqRQIqzsIy3U2zragbx0hAKBWHZwvBpjvDUCFaHyaFuNu0hL
         UJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AVrUmUhOU9NG8giPbmZ+OQFPwWBxRcnAm3gvzplbY84=;
        b=FnXx3VUMZMLSr4UPP9tPgXcVQRC7y9Qk77dzIfIIGDP3z2Dzsj2Z6szvFOZ7TIwFUh
         BEwcepMQGj+UMKwqu+WHPHOJeQozUQ996bJMjYEv3hZmALUyK+elZaIbQpH3ak6m2Aq7
         cIDF441739mVOPXB/I4BGgs6CzJ2734kEwrnwJIJFhl4WwROoMt9c4Cu+z5WhmFIkHAH
         DgG0rmb+8mCCxqlr8uJGV0e/M5xLxgJFgZjKltMneLKS6MakivRxn9g9HrSMjLKtkVVi
         8WJMxYEZNNdMathSkLHevRbTasCn9Y0sQqfKgKrfNjfagx3y1IL6m7AV+U6Vv43dDQ11
         tnWQ==
X-Gm-Message-State: APjAAAXz09Y6QV9cmKOzfOICCDppL3sApdwyXrnr/NxHMtqUm3YGJrzg
        93iut0fxjQwoUGiRfUYPbV+vsQ==
X-Google-Smtp-Source: APXvYqxxWhap0fKaSLfGgI2GfnXexw4Mbbmo0JARAhuyfhsuZ5EEhmGM6qbKS63yCqFJhBCnjS18vw==
X-Received: by 2002:a5d:46ca:: with SMTP id g10mr13393287wrs.193.1571518923348;
        Sat, 19 Oct 2019 14:02:03 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id t8sm9695982wrx.76.2019.10.19.14.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 14:02:02 -0700 (PDT)
Date:   Sat, 19 Oct 2019 23:02:02 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v4 2/2] net: dsa: mv88e6xxx: Add devlink param
 for ATU hash algorithm.
Message-ID: <20191019210202.GN2185@nanopsycho>
References: <20191019185201.24980-1-andrew@lunn.ch>
 <20191019185201.24980-3-andrew@lunn.ch>
 <20191019191656.GL2185@nanopsycho>
 <20191019192750.GB25148@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191019192750.GB25148@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Oct 19, 2019 at 09:27:50PM CEST, andrew@lunn.ch wrote:
>> >+address_translation_unit_hash	[DEVICE, DRIVER-SPECIFIC]
>> 
>> This is quite verbose. Can't you name this just "atu_hash" and be
>> aligned with the function names and MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH
>> and others?
>
>Hi Jiri
>
>I would use ATU_hash, but not atu_hash, sorry.

That, I don't understand at all :/

The devlink param namespace is full of abbreviations. For example:
iwarp_cmt
gre_ver_check
enable_sriov
ignore_ari
msix_vec_per_pf_max
msix_vec_per_pf_min
fw_load_policy
reset_dev_on_drv_probe
acl_region_rehash_interval
enable_64b_cqe_eqe
enable_4k_uar

Why your thing is special?
Could you please follow the rest of the existing params?


>
>Hopefully somebody will implement bash command completion, making it
>easier.
>
>  Andrew
