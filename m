Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4431939A7
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 08:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgCZHau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 03:30:50 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:56270 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgCZHau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 03:30:50 -0400
Received: by mail-wm1-f42.google.com with SMTP id z5so5340961wml.5
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 00:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rKeCuonrWi0YEx5+8ZGW3YnOA8KyjeB0GSNz8ZNZTKg=;
        b=TQ8GTLPKZAkhoi8It4m0ynRDgKkl26UMfszcrx1Peoy6JQaHappZ6cy+DpdN6D9Zv2
         1ZnlGMon02rRKwW6Mfpi3UFMNPnycnrvTmwLO0M0CAlM2OqT/erukm/pqeHFtmeEdJD1
         NPGJLGK9q0aZZ/Gs3Gboy8YY+5ma3qLXa196A9pLCJQWRZSPSHjRse1V5F5lTAAnaQjk
         NvQAmSZtECyyihY43aWveEjhHzFLog7OnZpSVFhLSYc78kNXs0jZqXrOEJdj7i3ajqFG
         NlITdanEDyhvymLfJUGPhP3lRaFrT7jsyT3nqE+GtO7YP/uHnN7lZDUPB1cMqrOSD1/z
         lGsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rKeCuonrWi0YEx5+8ZGW3YnOA8KyjeB0GSNz8ZNZTKg=;
        b=AwBdBmO13tT3xtK3tNLiEihXwzUPT1ZICW+kKtXrjS/prfZnNnbFgOu6/pkTUJprMv
         rtahzk6966KRjm1gnR5uObzeYJt1Ga8NlxmOHWYUgwL1VpsMs1Aa0Mfz50IR6MsMRLzD
         LwXSsbAjvKoVxJppsd8aZvkO2Hu1HUBYfP7nGFjssxei0fOsAEkcBBPGfBwXT9iCuh3d
         ukE5MZJwIyfimr1rTLKyFUb3tTODEawT4Une9Az5w+isMauaKL4T1oPqq10+B4z6p3L9
         hXQlDPMfTaicmpNsJILejMf89/gM4q8ehr5sGJo7dZWKlCFOmduGYt1wpHhSSmcwAii4
         WOfw==
X-Gm-Message-State: ANhLgQ1NLMiGLbUCMBoGvgo7oSoTzIsGgdfmF0zvHsvrCaLjnACK88dS
        BMTWhx2b0s8JtZsfeVzb0MZQZA==
X-Google-Smtp-Source: ADFU+vvCOW4V/6pkPpeuWeRikLCKqJnJr4FdHP0mT9d2LjlT51Nm2zvRtkVNLHpORaQFnCrxdyykHg==
X-Received: by 2002:a7b:ce81:: with SMTP id q1mr1735346wmj.156.1585207848418;
        Thu, 26 Mar 2020 00:30:48 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 61sm2413368wrn.82.2020.03.26.00.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 00:30:47 -0700 (PDT)
Date:   Thu, 26 Mar 2020 08:30:47 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next v2 07/11] devlink: report error once U32_MAX snapshot
 ids have been used
Message-ID: <20200326073047.GJ11304@nanopsycho.orion>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
 <20200326035157.2211090-8-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326035157.2211090-8-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 04:51:53AM CET, jacob.e.keller@intel.com wrote:
>The devlink_snapshot_id_get() function returns a snapshot id. The
>snapshot id is a u32, so there is no way to indicate an error code.
>
>Indeed, the two current callers of devlink_snapshot_id_get() assume that
>a negative value is an error.

I don't see they do.


>
>A future change is going to possibly add additional cases where this
>function could fail. Refactor the function to return the snapshot id in
>an argument, so that it can return zero or an error value.
>
>This ensures that snapshot ids cannot be confused with error values, and
>aids in the future refactor of snapshot id allocation management.
>
>Because there is no current way to release previously used snapshot ids,
>add a simple check ensuring that an error is reported in case the
>snapshot_id would over flow.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

The code looks good.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
