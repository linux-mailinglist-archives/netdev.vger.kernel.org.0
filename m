Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1166F34DD6
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 18:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfFDQlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 12:41:10 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34302 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbfFDQlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 12:41:09 -0400
Received: by mail-pf1-f195.google.com with SMTP id c85so4233531pfc.1
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 09:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E35jc+uAOqXLXpmUJ3PTU6SSnWfiQJ5YDsalNFzboww=;
        b=d8bTqoMh/tYxD/p6FSHM09MtcT4FHUU5W2rJQLLR27h16ADz7QK5V/bWwGyQazZryJ
         mX3v5MlYcuyw1qtFNlF9FdX/5RSWgFAjeKFouGA9xFAeI4h+OEQd4CSfO1003eBgUUaT
         AW1rN934G8w93lwB8xGdb3K4YvQzdiHBXNzc9PB3y+4AUZPJCO8FrggqFHnLuFhxRhQe
         lth6tndmZnhALotfM9zMU+iWinJCt+xgJHXY34lfc06Qtvk9BuROarcwVsib7l55/zem
         kA3UpmhypS7N28UVeoTTHKhTHnVXuq9FWjv3xhJ8X57wmBMTj4ENscZZH9xsWHtotfxM
         z0FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E35jc+uAOqXLXpmUJ3PTU6SSnWfiQJ5YDsalNFzboww=;
        b=Fo0OLGGhNIHPv3ZTZg34RUQ2v94TYuQjDPzP5HGfA9Ls0V11HJoHwJUlVscxhl2RUI
         F1BfUAxDdf1GhrT2UP8o5Q22wSY8i3a/NCK6+BPGHHljSfbUAZO35p6fAC5ZVdmISJ3G
         XRNDnjDgcjlXmYhn5iUQhuuCKinhLioQib7rTENJsSPkIWOrVblTLJIxLILwmsp+T4yi
         gfTWkcQ92JcpXYTcDIbLVwY0zky48nuZbSB7UILhuKqTwpa4gwcetW1QDVUtn0ibbJ9V
         DjJxtbklpnFREAhvji3luDKb/8WV86GGYHI2OamhGCceGLe15PaosAMuLdIbdZt7wKnr
         S/Ww==
X-Gm-Message-State: APjAAAWC/F29lmoNiqHzcEmOu0g91BobQt+46V7hOlcpfxaXfZ2BgJ7Q
        n/4DFgROW45hHFZ70h18+OdasplE5UU=
X-Google-Smtp-Source: APXvYqxYv4VP74XzTHBiE1vEUbErcDYDhdq52maUcdYCuGTTLYSSE1PpxGqPuVU1okYrM3AigReyGg==
X-Received: by 2002:aa7:82d6:: with SMTP id f22mr40566452pfn.151.1559666469053;
        Tue, 04 Jun 2019 09:41:09 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id b15sm18255474pfi.141.2019.06.04.09.41.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 09:41:08 -0700 (PDT)
Date:   Tue, 4 Jun 2019 09:41:07 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     netdev@vger.kernel.org, aclaudi@redhat.com,
        Qiaobin Fu <qiaobinf@bu.edu>
Subject: Re: [PATCH iproute2] man: tc-skbedit.8: document 'inheritdsfield'
Message-ID: <20190604094107.6834422e@hermes.lan>
In-Reply-To: <7d450cb1d7bc1cde70b530930e0a5d73e39f4fdf.1559304622.git.dcaratti@redhat.com>
References: <7d450cb1d7bc1cde70b530930e0a5d73e39f4fdf.1559304622.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 May 2019 14:12:15 +0200
Davide Caratti <dcaratti@redhat.com> wrote:

> while at it, fix missing square bracket near 'ptype' and a typo in the
> action description (it's -> its).
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied. Thanks
