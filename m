Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C92E12B09B
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 03:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfL0C2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 21:28:06 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45250 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfL0C2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 21:28:06 -0500
Received: by mail-pl1-f195.google.com with SMTP id b22so11150950pls.12;
        Thu, 26 Dec 2019 18:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Obn5ZfP5UjGU4WoFE5OblIDkH+UMv+VcP9PdkMDPB6s=;
        b=pv3hA5nAE1VY79LAzp21jKfYCwIzc5KgbNd43LOfVjJhwRd1C9yqwE5dRCu1lOG08S
         bMtfQvV2hhyuzTfmhGBpfDEnPklETG9xSShlhdYii0zIb5+wqvYiGbbqh25au5AFzbs5
         20wmFduxVfR3RKP8AT+OtBVG+g8LSSZv3fbH27tUupSutaIbiT6DvAEkV7OBYjX9Q2tu
         rVWDtIoQFYFzbl2kH0TDG8Yt902TQP6bjjf+168RZubOoLxoduQRa8QSeG4Ey7ujX1aU
         4oo6kgXn8+WVhOAHihNvkncVnWGrXMHk02D65AjhfM1zfbJYath9TgaLmp3Weku0k7YL
         ikhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Obn5ZfP5UjGU4WoFE5OblIDkH+UMv+VcP9PdkMDPB6s=;
        b=J/kPCgIeX3fCNbvW8mcwqu3bwS4X03kCH2LV/08sKxDt2+M/q7dbpHJSoKNIiHc1/P
         FSpJwtYlobeD/asVGGDZ0IBi6n8vVab8Ye9vA38RVlYgMzA+eOW9AOKaUq9G+jZiP4JX
         LBfQM18LtNICEVhK3Lpwq/Zl5hlyasdy8PQa0zGI9nVmz9P57Js0c1xWoY1RO0DXoZ3F
         J4opJ4zykcj/usv/e+f8vix4Nl6CIxXn4Okc6xiYq7vgZrsqXNcQ+osEs57YJ4Ad8dna
         HP2CWRSGWnQoamw9L6L05rBz/gljmZWEpIxckTzsALvHNUaS6jwQZeUQ16dBvFmp75zJ
         M61A==
X-Gm-Message-State: APjAAAUB/og2eHEPI2ZWjOdjkOz/e10qqZuZAGo5nfXAbv1oe/XZBvNU
        IdDQECripuPDOkCq3QUHyng=
X-Google-Smtp-Source: APXvYqzrCjb3aV/tuiz+Ky4tXiNI26TLEax6W22wW/volPxRMVvDFVjTpwnwWCxRI0Q1spLRI9qfFA==
X-Received: by 2002:a17:902:b908:: with SMTP id bf8mr23456689plb.293.1577413685042;
        Thu, 26 Dec 2019 18:28:05 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:eec9:70fb:c1dd:a590:57ac])
        by smtp.gmail.com with ESMTPSA id 3sm36158704pfi.13.2019.12.26.18.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 18:28:04 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id A6890C0D74; Thu, 26 Dec 2019 23:28:01 -0300 (-03)
Date:   Thu, 26 Dec 2019 23:28:01 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     qdkevin.kou@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next] sctp: move trace_sctp_probe_path into
 sctp_outq_sack
Message-ID: <20191227022801.GI5058@localhost.localdomain>
References: <20191226122917.431-1-qdkevin.kou@gmail.com>
 <43c9d517-aea4-1c6d-540b-8ffda6f04109@gmail.com>
 <20191226.153835.1092744996447366504.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191226.153835.1092744996447366504.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 26, 2019 at 03:38:35PM -0800, David Miller wrote:
> From: Kevin Kou <qdkevin.kou@gmail.com>
> Date: Fri, 27 Dec 2019 07:09:07 +0800
> 
> > 
> > 
> >>From: Kevin Kou <qdkevin.kou@xxxxxxxxx>
> >>Date: Thu, 26 Dec 2019 12:29:17 +0000
> >>
> >>> This patch is to remove trace_sctp_probe_path from the TP_fast_assign
> >>> part of TRACE_EVENT(sctp_probe) to avoid the nest of entry function,
> >>> and trigger sctp_probe_path_trace in sctp_outq_sack.
> >> ...
> >>
> >>Applied, but why did you remove the trace enabled check, just out of
> >>curiosity?
> > 
> > Actually, the check in trace_sctp_probe_path_enabled also done in
> > trace_sctp_probe_path according to the Macro definition, both check
> > if (static_key_false(&__tracepoint_##name.key)).
> 
> Indeed, thanks for the explanation.

It was duplicated, yes, but it was also a small optimization:

if (enabled) {
  for (X times) {
    if (enabled) {
    }
  }
}

So it wouldn't traverse the list if not needed.  But X is usually 1 or
2 and this list is already traversed multiple times in this code path.
