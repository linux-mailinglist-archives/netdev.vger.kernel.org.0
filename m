Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF910402EF5
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 21:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242169AbhIGTaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 15:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhIGTaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 15:30:24 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE58C061575
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 12:29:18 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id i13so38368pjv.5
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 12:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BtKGEzdVmi50092yMDMJBSjRiy5K/a3IYUjhcK1D73I=;
        b=TBbZj0TqHM/wyC5xp8DtvmpUMpDm1uAoQkdDD3Ee/qovyk/FBPmGrPwXJ/RJpbl9+j
         sOWx2k9OJXS2qs5cCaextzhf77unrWmrxxiXciFnuYUhdzOImnv4RAW1cDV+81G2TQsC
         nduvs5b5diRq4Erwv/N0qbfxri4M0MEVGpLXEfrjrIO1FXkN9AEQuVGN7ktuUrTPmNx+
         v4ldmblXfdb4hmRXhgUpm0UYvAZPWRJTr00cZxY4K8vQ3WGZOnrprIxz71oFMLgwnmyj
         Zkno2TmbQx393gXfhcK3t7farp5Xei6UqxeKiRBVOj5vDKwOCm3h/kkFCpxQKLsi8sNb
         yo2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BtKGEzdVmi50092yMDMJBSjRiy5K/a3IYUjhcK1D73I=;
        b=dCeJ/phfCt7I3yiWujqmcaCtRWEICIQHY6S1GJyYzZ3lsNVPiNi+br5Jkiyr3xxTtR
         QYnBN1ZgmAJV0YsZCvDX9xkKEZAuDH3FFl5OyXs3AWOFgl4YDXTzZP3zr3AyXLys9GUF
         f0xMfhbzJUloy+fs4Gj+MnOkpszPjTUsTpT7cXW0NGasqD+bcDrKqwQVfsBMnF6GiAeO
         5CZjkuyL8lOswkptMwfagNzo02fxcwyjL5ljTo6ywPSuJGjl8iRgVZznmrBgm5b1yqu0
         OTizAKpUjKOz273WQrvnsjOj2gz6R51FMRuP6+U2AidwSD8WZJmQIZb5pHQZ0zJV3SCw
         OfKw==
X-Gm-Message-State: AOAM5319v9A2pJxj7sTEhjFeAhQ79I71/V8oZefcfCQOgfwPFjjkNX7D
        QsZv0ZnXKhhGaW2VqmeH1yGhvB9oSK0/yw==
X-Google-Smtp-Source: ABdhPJwq6QfDh5jYe2DpNV6JXXGeac1j5e4vc9h3o4olZ6d6/stoS76IcgL1P4j8GXBO2arAdwudjQ==
X-Received: by 2002:a17:90a:680c:: with SMTP id p12mr8945pjj.33.1631042957834;
        Tue, 07 Sep 2021 12:29:17 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id g7sm11740250pfr.126.2021.09.07.12.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 12:29:17 -0700 (PDT)
Date:   Tue, 7 Sep 2021 12:29:14 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Wen Liang <liangwen12year@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com
Subject: Re: [PATCH iproute2 1/2] tc: u32: add support for json output
Message-ID: <20210907122914.34b5b1a1@hermes.local>
In-Reply-To: <5c4108ba5d3c30a0366ad79b49e1097bd9cc96e1.1630978600.git.liangwen12year@gmail.com>
References: <cover.1630978600.git.liangwen12year@gmail.com>
        <5c4108ba5d3c30a0366ad79b49e1097bd9cc96e1.1630978600.git.liangwen12year@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Sep 2021 21:57:50 -0400
Wen Liang <liangwen12year@gmail.com> wrote:

>  	} else {
> -		fprintf(f, "??? ");
> +		print_string(PRINT_ANY, NULL, "%s", "??? ");
>  	}

This would be better handled by printing a real error message
on stderr, rather than continuing this confusing message.

+		print_lluint(PRINT_ANY, "rule hit", "(rule hit %llu ", (unsigned long long) pf->rcnt);
+		print_lluint(PRINT_ANY, "success", "success %llu)", (unsigned long long) pf->rhit);
+	}

There is print_u64 which is better than doing these casts.

+				print_hex(PRINT_ANY, "offset mask", "%04x", ntohs(sel->offmask));
+				print_int(PRINT_ANY, "offset shift", ">>%d ", sel->offshift);
+				print_int(PRINT_ANY, "offset off", "at %d ", sel->offoff);

Space is not valid in JSON tag.

Please test by running the output from your changes into a JSON parser.
Example:
     tc -j ... | python3 -m json.tool

