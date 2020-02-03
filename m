Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE6351500E0
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 05:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgBCEIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 23:08:44 -0500
Received: from mail-pf1-f179.google.com ([209.85.210.179]:39668 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727327AbgBCEIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 23:08:43 -0500
Received: by mail-pf1-f179.google.com with SMTP id 84so6843091pfy.6;
        Sun, 02 Feb 2020 20:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3REyJuz7VqLVqGz9lSZ6gGgw5tnssXBevLdzc15Hm3A=;
        b=qfyJY2Q+RwVBOzWlg0P5bGX8RreHjh4rr0IXVGkiOeqH4VQ/VnCnSrW3HSJ6rf2F2U
         33OrvjYYIu5D9xPAb2H/EaadZLAxB+dt/bSv2rE2zqZfCLjWY+oTt5CZw+DdbuDdg458
         2TjDHNUDnbKbU8mTA2BbehsnvDjI890m+3H63a0qxSy8Hyz5jSHEw/Cs1f58kVEUnSjA
         ffdQTedZ6x7DOSGH3NoQP2HKEGXTtfNfGp69k4fK1pc7pHZrVMfVRQTnREG6a86QIdEK
         SrxJReZ5xWqngbyy3Pwfgfc2ZUWDJ/tziOVmtt9v6nJqroHjW0jhwxSaSrbeE0SXw3Qv
         /9Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3REyJuz7VqLVqGz9lSZ6gGgw5tnssXBevLdzc15Hm3A=;
        b=rfCn1p/QGssZkFHPa2RtYUZ6yDiQKlJQPZBnXhP+z9RzmYDaVOvECP/IQDqYkCoYJY
         nPup/DviJfWndlNXyD1wikUm9FUDw+qZIeWwc3clDJ8epopWnlDO5DKkEhRfWAJPNiC1
         L+1ppU74dCV5/qpMZdhdhT8DVMCvd+kkSR1ffC9Et5lwEfKaF27CR+m8+980fRzH3kz8
         TSEnGXxtl2k/VQgWv/wh0S8mJ+HzYFu8r/nPkO4Ra7KKdOtqDTEdgGtxHEH3YrJRUCzI
         GM/pD+aVTB1GV+/3bu8W1Jh5mVZcjw1rc8eUJSMR1xOWzV4ZuiWI1X3+XBISHqMI08BU
         jkrA==
X-Gm-Message-State: APjAAAUr4OvdqTt2vvhtEiUWWg05GcjNStTYhzNQOrqYej55Cqm/Ipke
        xos9IuIJprK/6VgUbtRAwks8KFNK
X-Google-Smtp-Source: APXvYqzWCVie19A1ToCO4CJfRWSUHBI0lkY5p9Rk/KjdH2DxDzIRvgn3EgezaT87Cl9r6J/CcyXaGg==
X-Received: by 2002:aa7:98c6:: with SMTP id e6mr22859126pfm.251.1580702921623;
        Sun, 02 Feb 2020 20:08:41 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 13sm17717043pfi.78.2020.02.02.20.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2020 20:08:40 -0800 (PST)
Date:   Sun, 2 Feb 2020 20:08:38 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     christopher.s.hall@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, jacob.e.keller@intel.com, davem@davemloft.net,
        sean.v.kelley@intel.com
Subject: Re: [Intel PMC TGPIO Driver 0/5] Add support for Intel PMC Time GPIO
 Driver with PHC interface changes to support additional H/W Features
Message-ID: <20200203040838.GA5851@localhost>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211214852.26317-1-christopher.s.hall@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 01:48:47PM -0800, christopher.s.hall@intel.com wrote:
> The ART frequency is not adjustable. In order, to implement output
> adjustments an additional edge-timestamp API is added, as well, as
> a periodic output frequency adjustment API. Togther, these implement
> equivalent functionality to the existing SYS_OFFSET_* and frequency
> adjustment APIs.

I don't see a reason for a custom, new API just for this device.

The TGPIO input clock, the ART, is a free running counter, but you
want to support frequency adjustments.  Use a timecounter cyclecounter
pair.

Let the user dial a periodic output signal in the normal way.

Let the user change the frequency in the normal way, and during this
call, adjust the counter values accordingly.

Thanks,
Richard
