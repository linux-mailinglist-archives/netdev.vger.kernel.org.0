Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B4A119193
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLJUKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:10:51 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:34084 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfLJUKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 15:10:51 -0500
Received: by mail-qv1-f67.google.com with SMTP id o18so4738927qvf.1
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 12:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=tPg6HNf3WY8ezIcG4ChbTF8Z6mYyQlYkzlIgv8Ay1G4=;
        b=nE8UgUJtn+wZBfPfQc9Kq8XZE/NBo5vuY5hCaYf6g6ft38NS2ub1gyF+Z7ue6zCAaY
         fg82czGJCLVajza/WZTB7T8FUAUJM81ERVaH7iG7J4gyCtRX1eVi/zZR7E/fLGGSmN3u
         E9vgL/GwbtMd3J9NNG1XS4soWjFM3rE0QQr1Xn1nek4OoaAfxXZKbTBiu53kROlK6bQm
         BUOEIihJeok88kcFgYkJYReIuBjuhl1hMc8zuF07xbTL6mHXHrmMGRYYXloD4A7aqQrR
         43y+oIVzY5WfrL04wULu9vw+KrIP5yZT2bWPHZXfgxYnYHkwjA21mb+pTBp2IFXqmShy
         etdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=tPg6HNf3WY8ezIcG4ChbTF8Z6mYyQlYkzlIgv8Ay1G4=;
        b=FH9e8cICqeCL1Nxv/CPQXhUwf8C6Igs2hLLUVUref16hZWsa59FEbTSyANV8MPQKDV
         XarDm4YwekGgzttGZZdTXL8Y6INBsnN1kK8oqhiu7cxg4S/zzYZvOiOCR4n5VdtbaxH/
         eifpA2nDBRNEAT8up1rPUQOF4IdIpu+gpNSjzqtkUjP6ZjIjXI6T276UkqI6X/l5ggI/
         lN4A5l6471Jic5iNEqfLOH1h9kC0QGREc9WK7rRTzX6trmBeQ+KrukF3u2Ce1tOgrs9J
         Rh1Bmv1OB8UJxGGrnE8aQLUvgzXUWm34A2S8nOJ6AWquhQsiicGlSILjtIdYj9xEx0hQ
         O8NQ==
X-Gm-Message-State: APjAAAWEDWjaCdyi2k1hGNoJiG3njS3lacSiEMSNd5eymCKk2IzuVDqZ
        9VAFQbzLQWWFsQ30ZpmvfQZL+vx3fwo=
X-Google-Smtp-Source: APXvYqzFW+k63CcJTwg4KLlPQFkVd3B0IL/8hW8ebFwVwxZIQzDn0kcboWLvm73YdeEE8k0mw5LWvQ==
X-Received: by 2002:ad4:496f:: with SMTP id p15mr29714803qvy.191.1576008649750;
        Tue, 10 Dec 2019 12:10:49 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 200sm617114qkn.79.2019.12.10.12.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 12:10:48 -0800 (PST)
Date:   Tue, 10 Dec 2019 15:10:47 -0500
Message-ID: <20191210151047.GB1423505@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net-next] net: bridge: add STP xstats
In-Reply-To: <2f4e351c-158a-4f00-629f-237a63742f66@cumulusnetworks.com>
References: <20191209230522.1255467-1-vivien.didelot@gmail.com>
 <a3b8e24d-5152-7243-545f-8a3e5fbaa53a@cumulusnetworks.com>
 <20191210143931.GF1344570@t480s.localdomain>
 <2f4e351c-158a-4f00-629f-237a63742f66@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay,

On Tue, 10 Dec 2019 21:50:10 +0200, Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
> >> Why do you need percpu ? All of these seem to be incremented with the
> >> bridge lock held. A few more comments below.
> > 
> > All other xstats are incremented percpu, I simply followed the pattern.
> > 
> 
> We have already a lock, we can use it and avoid the whole per-cpu memory handling.
> It seems to be acquired in all cases where these counters need to be changed.

Since the other xstats counters are currently implemented this way, I prefer
to keep the code as is, until we eventually change them all if percpu is in
fact not needed anymore.

The new series is ready and I can submit it now if there's no objection.


Thanks,

	Vivien
