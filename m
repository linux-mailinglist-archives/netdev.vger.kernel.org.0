Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84DF2EE0F2
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 14:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbfKDNZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 08:25:13 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33292 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbfKDNZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 08:25:13 -0500
Received: by mail-qt1-f194.google.com with SMTP id y39so23906317qty.0;
        Mon, 04 Nov 2019 05:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DKdIIDMLF5QN6l/0M8nP34uwWbd87SXNqY0koiCvQwQ=;
        b=nq/YeMXLeglOeQcEZQFkaG+fSMvfxip3W9YvwMRMWj4zIgxjKGo6a3t5NZ5iYPfG6F
         h1V2nyKF3f8fZHZU8QICqnMecncDfNxQsGwCYFjHsfF714asOAHYlDiGiuMgwsN7RtDL
         EpsQifi/nryaSXVlvXoA7eZNDiTELpitMBcDimKTuVrxBg54r8dgQcDuu/fcr7kjfOiO
         cqTDFPTv+szVRT8RSCIAyrYW3GT0geuRSzq+TCQuxBNnpulgoDLssBvD7/kTbEcy9rdt
         IadRrExN+ey1/Q47MRPfO+KjjrGtl8KchREcAeDVz5/mTFbkCnA4UmZ9BSjBztvQkKAe
         dnCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DKdIIDMLF5QN6l/0M8nP34uwWbd87SXNqY0koiCvQwQ=;
        b=HJnXZjTyj87ErG7fFe5aDooxchJkj1I84GO0iNJpK0bK/uPyJRTpeDuJaGr923d2Ts
         9Ss0asqNlteGz2vDSmV4d2VnWypLPpiWuqjocL4Vv4TPu8EplIMTRKG1/hK5+cSNhhZ8
         oD2rfTpnPjQQ8VST4XhZAR1r1G5Utcpgx5PY2I3ZriXU4i+g/5CIIfy5jc7cxyD4NZJE
         wZWG1IqqVuGr5O2nhNMoVpOqaEG3C5QV2Tm5/QcyLYAxNf5cOUODYXsmpRTCCaFRYObg
         f3j/Ed8axhNb0P2tgJTUmJuNi21LW+dIWgd0UWv+YRztPgZvXiGVkf4OWMC2cSx7psau
         NA1A==
X-Gm-Message-State: APjAAAUUskIIG/sEFCxT6DboZhNOUgg4zjl+HSv00Wg86u4ZoNsnmIWJ
        2gFfi61rlCuHywlzq/3+P9c=
X-Google-Smtp-Source: APXvYqzmCpE1cXbKa+7oOSqluO7m5Rw1WPEyu+SjAQGUgdWquBeOGPMqq/aU3poYB+1xyXiqbzHL1g==
X-Received: by 2002:ad4:5386:: with SMTP id i6mr15440858qvv.84.1572873912147;
        Mon, 04 Nov 2019 05:25:12 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:146d:7dd5:a83f:defc:1791])
        by smtp.gmail.com with ESMTPSA id h186sm2546430qkf.64.2019.11.04.05.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 05:25:11 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id DD7B9C16E7; Mon,  4 Nov 2019 10:25:08 -0300 (-03)
Date:   Mon, 4 Nov 2019 10:25:08 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     kernel test robot <rong.a.chen@intel.com>
Cc:     Wally Zhao <wallyzhao@gmail.com>, vyasevich@gmail.com,
        nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wally.zhao@nokia-sbell.com,
        lkp@lists.01.org
Subject: Re: [sctp] 327fecdaf3: BUG:kernel_NULL_pointer_dereference,address
Message-ID: <20191104132508.GA53856@localhost.localdomain>
References: <1572451637-14085-1-git-send-email-wallyzhao@gmail.com>
 <20191104084635.GM29418@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104084635.GM29418@shao2-debian>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 04:46:35PM +0800, kernel test robot wrote:
> [   35.312661] BUG: kernel NULL pointer dereference, address: 00000000000005d8
> [   35.316225] #PF: supervisor read access in kernel mode
> [   35.319178] #PF: error_code(0x0000) - not-present page
> [   35.322078] PGD 800000021b569067 P4D 800000021b569067 PUD 21b688067 PMD 0 
> [   35.325629] Oops: 0000 [#1] SMP PTI
> [   35.327965] CPU: 0 PID: 3148 Comm: trinity-c5 Not tainted 5.4.0-rc3-01107-g327fecdaf39ab #12
> [   35.332863] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
> [   35.337932] RIP: 0010:sctp_packet_transmit+0x767/0x822

Right, as asoc can be NULL by then. (per the check on it a few lines
before the change here).

  Marcelo
