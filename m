Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC7B12B0F2
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 05:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfL0EVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 23:21:32 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:42304 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfL0EVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 23:21:32 -0500
Received: by mail-io1-f68.google.com with SMTP id n11so18081826iom.9
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 20:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vp1zUWFfMJbPwjNwGZYi2NI3d5MRJoMD0OgMPupzV2E=;
        b=s+nnqUaU2EkwIeL0Ey0zE5A6FIrmmMxUR2z7rshnqoe9vQ+fMgLz4K+zQKZx4md9fM
         6HaR+6wQk9zWJNbSPZ5KBHuME+Zzy9g8Y9k+PVVJnAY96qULZoysr9SuzYeA/Vhp3SZ/
         l9XaHJoi1SRTUE4F+6RG4YDxQWQEgXAgEkcVsRXoQt8ZrzGi0oiVFX/N35WupS02Jbly
         7RIxw4E+p8UDhOGFBptMP/Hxqqv8Z9iXR8+VcgDRusw8o+zzLhWWsfAI+OIo8yVU1UAs
         EjiJeGfV04KigG8sp6qeyYip6KpeSD3biopl2R03RmFQGpJP5Tail8A7FpHUmOchvJzP
         +1VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vp1zUWFfMJbPwjNwGZYi2NI3d5MRJoMD0OgMPupzV2E=;
        b=mydyNBgeQ/rHxYwJltU9m+kMQDn5N6USGDS/okg80NhS8Voi1JT/S/3dmlsvW3f9WU
         YxSYPWEbK75Qb9WfMV6EP406GAMDsq12h0Q9Zu/0QjNRGmD2WAGRmZogsegXVL+aTdwF
         302rmM4vAwZY6gkjkZ4SUUIpadzmEzqHzRoyPJXRU3esX/xBtAD3G0Il8pfPNd7KjZG2
         utp80bJtTsXEJhQ5wTLhplPq9myov7JjMdLvaKXi6eaXVqqJA5k3YBdzhJAUbS2DCMGA
         /ULGgSvEzsv73lpGos5jILTVSNbtVLG0m+7QsLWpPDlgqTWklfpphG3AFi3bvB6wuTVm
         SuHg==
X-Gm-Message-State: APjAAAUVNFtLjYttcKGXma/V5Ts9SGM3e7WDBR1vDDCaNHWG5jFqW3G1
        8VJgaETH15iYGpBlPXmYPAU=
X-Google-Smtp-Source: APXvYqxD5p0T6EZlg3WXbh2YWKSEXWLXexr12xAAtJxmh9JBXRXRdfwy3oS1KBHdew1aJZ4+8WqWLQ==
X-Received: by 2002:a02:94e9:: with SMTP id x96mr37448242jah.68.1577420491397;
        Thu, 26 Dec 2019 20:21:31 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:859d:710a:f117:8322? ([2601:284:8202:10b0:859d:710a:f117:8322])
        by smtp.googlemail.com with ESMTPSA id q1sm12868884ils.60.2019.12.26.20.21.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2019 20:21:30 -0800 (PST)
Subject: Re: [PATCH net-next v2] bonding: rename AD_STATE_* to LACP_STATE_*
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Andy Roulin <aroulin@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net
References: <1577367717-3971-1-git-send-email-aroulin@cumulusnetworks.com>
 <20191226182042.3ca9cd94@hermes.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a86dd927-d14f-5afb-1934-04a1b1d77d52@gmail.com>
Date:   Thu, 26 Dec 2019 21:21:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191226182042.3ca9cd94@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/26/19 7:20 PM, Stephen Hemminger wrote:
> You can't change definitions of headers in userspace api
> without breaking compatibility.

this is a new uapi during this net-next cycle.

