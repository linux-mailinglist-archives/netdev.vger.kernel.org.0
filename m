Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42016A44E2
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 17:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbfHaPBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 11:01:53 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:32954 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728285AbfHaPBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 11:01:53 -0400
Received: by mail-pl1-f193.google.com with SMTP id go14so4666948plb.0;
        Sat, 31 Aug 2019 08:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wb/A0nLfYSOW2oh301mQSunagMCByFHKWhdM0f4nMws=;
        b=BVy1cPedwKZIPpS9m31cRI6RXGHB3AfxEHnmky4WC//YrFjYix6lDPI0RP+F2X2uU/
         nyLSgCVc2Y09hgNsy48NVWBdKogqMMoPk/asQ/sYdQeJQo3dg+fPM/g+3omdsNWN54pK
         W1Jt7vZcA93fzjmCDP8qewc8OyuQzUvbRXQeKTSW4ynDOkvCYm7ugEIIVBg2ncVLmTvm
         d0817ItdSSvMHYFC8HwOPA/jdHPKIwA8cdlY7dGxHjnSqwRsfcW+M4sZyLlj4t8BVdV/
         W0Jxgv3uRjz24X0mroL49extd3AHnQnRzKT/PUtITWeJhbIy+D0Xc8V/25YDLAUw7SjQ
         O2FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wb/A0nLfYSOW2oh301mQSunagMCByFHKWhdM0f4nMws=;
        b=ftZa+eQ/Qo5G14jT3kxwEL0CECUL9X416oxiIK0oECeviJ0wV6VUSIjEtR78cCpzeu
         fS52WCXnxZKm/8pHeVhhvya3mULf135MhPGRkvRJBUV0UuTstg+yWfccBoc/+Js2Ub0m
         GEJAypKnGlbthKnJfbcWi5qJm3j804buf6prBZ4h8EJHw1oSQLFA8mtLBxNE2tWUNWbE
         1qtyuz6YXuzppuKwWGkTXWDmJuoWvM34w1E3yfaZ/aMgPdaH5EvtVrj5jywocN5GIhbc
         zDhOBDI+5/2pq/oEfO2bxJZ6t+FJxXuY5YTbbJhvhKkXeaQdlnVwb+eK4swC7+KRiH4d
         NSRA==
X-Gm-Message-State: APjAAAXss9HUaYQca9PTNwb4x+QzjWstbvp+uymtx7MBk3C1jJPWx12K
        P2FxxxGKZVe07rYYLdH2TPY=
X-Google-Smtp-Source: APXvYqz2mPcJCisbPMZtjM02edLEv+BRcy2qBwemiwWT87BNtWW7Vhq2Ak1XGaq47eCcsQNcu+ZOIQ==
X-Received: by 2002:a17:902:1123:: with SMTP id d32mr21535084pla.218.1567263712480;
        Sat, 31 Aug 2019 08:01:52 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id i9sm21212123pgo.46.2019.08.31.08.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 08:01:51 -0700 (PDT)
Date:   Sat, 31 Aug 2019 08:01:49 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v2 2/2] PTP: add support for one-shot output
Message-ID: <20190831150149.GB1692@localhost>
References: <20190829095825.2108-1-felipe.balbi@linux.intel.com>
 <20190829095825.2108-2-felipe.balbi@linux.intel.com>
 <20190829172509.GB2166@localhost>
 <20190829172848.GC2166@localhost>
 <87r253ulpn.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r253ulpn.fsf@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 30, 2019 at 11:00:20AM +0300, Felipe Balbi wrote:
> seems like this should be defined together with the other flags? If
> that's the case, it seems like we would EXTTS and PEROUT masks.

Yes, let's make the meanings of the bit fields clear...

--- ptp_clock.h ---

/*
 * Bits of the ptp_extts_request.flags field:
 */
#define PTP_ENABLE_FEATURE	BIT(0)
#define PTP_RISING_EDGE		BIT(1)
#define PTP_FALLING_EDGE	BIT(2)
#define PTP_EXTTS_VALID_FLAGS	(PTP_ENABLE_FEATURE | \
				 PTP_RISING_EDGE | \
				 PTP_FALLING_EDGE)

/*
 * Bits of the ptp_perout_request.flags field:
 */
#define PTP_PEROUT_ONE_SHOT	BIT(0)
#define PTP_PEROUT_VALID_FLAGS	(PTP_PEROUT_ONE_SHOT)

struct ptp_extts_request {
	unsigned int flags;  /* Bit field of PTP_EXTTS_VALID_FLAGS. */
};

struct ptp_perout_request {
	unsigned int flags;  /* Bit field of PTP_PEROUT_VALID_FLAGS. */
};


Thanks,
Richard
