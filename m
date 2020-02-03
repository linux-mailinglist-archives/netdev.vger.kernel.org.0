Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 082B4150042
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 02:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgBCB1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 20:27:06 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:36397 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbgBCB1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 20:27:04 -0500
Received: by mail-pf1-f172.google.com with SMTP id 185so6679555pfv.3;
        Sun, 02 Feb 2020 17:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1Tq4h9ZZDh4yrfQKkZJ5ar+EXcbr5Jla2vvrbnBibGs=;
        b=Rp5g68WHKyEoWGW98IV7sNQv6Na6fJdLyehd0np+PwO8mX0B4GJhSTR5uzfsnTGA2P
         iRiDlscNeK9cW50Tjlbr7kaFBjecXKh4cwznKyl1tDhBqUqoZ5HDFpzg3igz3cC1MTtG
         1zgkLN3dcuC3fQD/AAT5PtWi/wzaRyVYtbMb2wshi0ZTlB8W9/fAyhFO+1cKlbvRgoVl
         T4DXPuB06DDk7KiTdMt4nS5afKDOQ3whbkOyMYUyI/+kucAfjfjq6AVTI3sfkH28eyyL
         Q7LFGUFx92QsxryrwOymj48wfemMrMXl93cr+B738hAzsVJIxil6z/eg4Jes19y8ANT1
         /u+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1Tq4h9ZZDh4yrfQKkZJ5ar+EXcbr5Jla2vvrbnBibGs=;
        b=pIKsAIdKd/sUifQtJ25Ph8BKxEEZuQoxteHXI0rJCLom1vjqYzNzbuMjIiDyWtVwH+
         BQY2NFTgbtU9EK1OGfjm2LOSnmrSFjdBBl85OUXv4gU/nc2f3n4z4sqKP1KK7F2T1oDx
         tqqJIlUv/tchL/2fhxMM2YT4mFnl4lEEi1GVux1gy268Ej3Y5JuT42W/NcZKOp2hGky8
         Uc3JItTAhv2UiyTqf3itYo3Ef71K/rz5DSJQ5ACJncDTX6VYsI8St/58OcZ+FNpEl+zs
         I68N1mmP5pYPPlFXYXReMAVOE3QN/R6UrHof5lFNkfsqJ1iZsmPHhzJm/xJ8dj3kVPO1
         PV+Q==
X-Gm-Message-State: APjAAAWqvNtfamZka6PCIBzSO4TcLT47AOeGYM6ky7aWx5gWr2Q58Sd8
        vIoE+xm/jqXM7G+Q8qLxakw=
X-Google-Smtp-Source: APXvYqxIWVmEoTEB2ZO9rvBUJOtfdafNBet3fWWmmi4glMqJgj1UshBRdAVzLnAaBBX0rLB3aeewZQ==
X-Received: by 2002:a62:ab0d:: with SMTP id p13mr22227648pff.135.1580693223295;
        Sun, 02 Feb 2020 17:27:03 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id t28sm18062385pfq.122.2020.02.02.17.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2020 17:27:02 -0800 (PST)
Date:   Sun, 2 Feb 2020 17:27:00 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     christopher.s.hall@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, jacob.e.keller@intel.com, davem@davemloft.net,
        sean.v.kelley@intel.com
Subject: Re: [Intel PMC TGPIO Driver 1/5] drivers/ptp: Add Enhanced handling
 of reserve fields
Message-ID: <20200203012700.GA2354@localhost>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <20191211214852.26317-2-christopher.s.hall@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211214852.26317-2-christopher.s.hall@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 01:48:48PM -0800, christopher.s.hall@intel.com wrote:
> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> index 9d72ab593f13..f9ad6df57fa5 100644
> --- a/drivers/ptp/ptp_chardev.c
> +++ b/drivers/ptp/ptp_chardev.c
> @@ -12,6 +12,7 @@
>  #include <linux/timekeeping.h>
>  
>  #include <linux/nospec.h>
> +#include <linux/string.h>

Please group these two includes with the others, above, in
alphabetical order.

>  #include "ptp_private.h"
>  
> @@ -106,6 +107,28 @@ int ptp_open(struct posix_clock *pc, fmode_t fmode)
>  	return 0;
>  }
>  
> +/* Returns -1 if any reserved fields are non-zero */
> +static inline int _check_rsv_field(unsigned int *field, size_t size)

How about _check_reserved_field() instead?

> +{
> +	unsigned int *iter;

Ugh, 'ptr' please.

> +	int ret = 0;
> +
> +	for (iter = field; iter < field+size && ret == 0; ++iter)
> +		ret = *iter == 0 ? 0 : -1;

Please use the "early out" pattern:

	for (ptr = field; ptr < field + size; ptr++) {
		if (*ptr) {
			return -1;
		}
	}
	return 0;

Note:  field + size
Note:  ptr++

> +
> +	return ret;
> +}
> +#define check_rsv_field(field) _check_rsv_field(field, ARRAY_SIZE(field))

And check_reserved_field() here.  No need to abbreviate.

Thanks,
Richard
