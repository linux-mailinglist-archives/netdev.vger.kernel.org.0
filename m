Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B754C3FB355
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 11:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbhH3Jnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 05:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235535AbhH3Jnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 05:43:41 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEE4C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 02:42:48 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id c4so8189989plh.7
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 02:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :in-reply-to;
        bh=u6vh4HbUmdIHZ6FD4Gw3ZP2l2415gBNYQscyL/6EFz0=;
        b=M1I9JIWJfxMwutBZU1Yd9/PMb2zRcZkI+PZxGWJvGArBBlKD+YLX1SSaUqw71RqPhy
         2ub20BLvFfGQwd1rb9hEDtBsrxvkaYRzkIuvsFZoYb+88Ms9yHXvkW4T7t4VjgcOnbfU
         RSZJ3HrAkvQiSTNs78nLWnD/VorpGVm6TMhxg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:in-reply-to;
        bh=u6vh4HbUmdIHZ6FD4Gw3ZP2l2415gBNYQscyL/6EFz0=;
        b=TIVZXNB29jhoFJdkdTSmWaMwie89PPMQFeMh6FRbB/e3Cz8bTje9Pn8Uf8krgyruDJ
         pRaKPuTHC+gjvn2ABPDRvic7vlvdWihATKj0Q1od3Y5XxJd45Ksrxh97qbZinsgVSQ2v
         /GUSf+QzAV2iMxyyeUdJOF713LELoRN2kqqO/YfYvc/8KsBQnnMfdYmbx1Qz7DeLIPc9
         XofKKA9uTPaYZhC0CYkDQBUqFG6kYsNy6VQVLK/FaUJRBRKqGssbME+Mw+xOmxm+hN7x
         5p/6/0ewzAcnby431OlRmmjbOtsGowbydRWm3LIPwUkXqYZPCkwZBX51GbciA6RjxbcM
         sQ4w==
X-Gm-Message-State: AOAM532URWIPbrFFVzon7LR+pG6kky2DSPa8WaD3Tc2bI5sVJiEMI9yO
        +K3L0EyZrwMH6Cd94t9wtXiaFw==
X-Google-Smtp-Source: ABdhPJxSjq4/SnEZQ2ofBPTCcwyS1FIjGIxl/WsFpscWZa0JJA7jAFfRKAwruu0rVOfa68SancvobA==
X-Received: by 2002:a17:90a:f18d:: with SMTP id bv13mr38680805pjb.70.1630316568087;
        Mon, 30 Aug 2021 02:42:48 -0700 (PDT)
Received: from noodle ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id g2sm2062386pfo.154.2021.08.30.02.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 02:42:47 -0700 (PDT)
Date:   Mon, 30 Aug 2021 12:42:40 +0300
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH net-next] net/sched: cls_flower: Add orig_ethtype
Message-ID: <20210830094240.GB24951@noodle>
References: <20210830080800.18591-1-boris.sukholitko@broadcom.com>
 <20210830090003.h4hxnb5icwynh7wk@skbuf>
 <20210830091813.GA24951@noodle>
 <20210830092128.he5itvsbysvbaa5u@skbuf>
MIME-Version: 1.0
In-Reply-To: <20210830092128.he5itvsbysvbaa5u@skbuf>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ee8b2305cac3a773"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000ee8b2305cac3a773
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 30, 2021 at 12:21:28PM +0300, Vladimir Oltean wrote:
> On Mon, Aug 30, 2021 at 12:18:13PM +0300, Boris Sukholitko wrote:
> > Hi Vladimir,
> >
> > On Mon, Aug 30, 2021 at 12:00:03PM +0300, Vladimir Oltean wrote:
> > [snip]
> > >
> > > It is very good that you've followed up this discussion with a patch:
> > > https://patchwork.kernel.org/project/netdevbpf/patch/20210617161435.8853-1-vadym.kochan@plvision.eu/
> > >
> > > I don't seem to see, however, in that discussion, what was the reasoning
> > > that led to the introduction of a new TCA_FLOWER_KEY_ORIG_ETH_TYPE as
> > > opposed to using TCA_FLOWER_KEY_ETH_TYPE?
> >
> > While trying to implement the plan from:
> >
> > https://patchwork.kernel.org/project/netdevbpf/patch/20210617161435.8853-1-vadym.kochan@plvision.eu/#24263965
> >
> > I've came upon the conclusion that it is better to make new orig_ethtype key
> > rather than reusing TCA_FLOWER_KEY_ETH_TYPE name. The changes I've
> > proposed there seem of a dubious value now. IMHO, of course :)
> >
> > >
> > > Can you explain in English what is the objective meaning of
> > > TCA_FLOWER_KEY_ORIG_ETH_TYPE, other than "what I need to solve my problem"?
> >
> > The orig part in the name means that the match is done on the original
> > protocol field of the packet, before dissector manipulation.
> >
> > > Maybe an entry in the man page section in your iproute2 patch?
> >
> > Yes, sure, good catch! I'll send V2 of the iproute2 patch shortly.
> >
> > >
> > > How will the VLAN case be dealt with? What is the current status quo on
> > > vlan_ethtype, will a tc-flower key of "vlan_ethtype $((ETH_P_PPP_SES))"
> > > match a VLAN-tagged PPP session packet or not, will the flow dissector
> > > still drill deep inside the packet? I guess this is the reason why you
> > > introduced another variant of the ETH_TYPE netlink attribute, to be
> > > symmetric with what could be done for VLAN? But I don't see VLAN changes?
> >
> > For VLAN, I intend to add [c]vlan_orig_ethtype keys. I intend to send those
> > (to-be-written :)) patches separately.
> 
> Wait a minute, don't hurry! We haven't even discussed offloading.
> So if I am writing a driver which offloads tc-flower, do I match on
> ETH_TYPE or on ORIG_ETH_TYPE? To me, the EtherType is, well, the EtherType...

AFAIK, the offloads are using basic.n_proto key now. This means matching
on the innermost protocol (i.e. after stripping various tunnels, vlan
etc.). Notice, how the offload driver has no access to the original
'protocol' setting.

ORIG_ETH_TYPE if given, asks to match on the original protocol as it
appears in the unmodified packet. This gives the offload driver writers
ability to match on it if the need arises.

Thanks,
Boris.

--000000000000ee8b2305cac3a773
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVgwggRAoAMCAQICDDSzinKpvcPTN4ZIJTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIwNzMwMDRaFw0yMjA5MDUwNzM3NTVaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGTAXBgNVBAMTEEJvcmlzIFN1a2hvbGl0a28xLDAqBgkqhkiG
9w0BCQEWHWJvcmlzLnN1a2hvbGl0a29AYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAy/C7bjpxs+95egWV8sWrK9KO0SQi6Nxu14tJBgP+MOK5tvokizPFHoiXTymZ
7ClfnmbcqT4PzWgI3thyfk64bgUo1nQkCTApn7ov3IRsWjmHExLSNoJ/siUHagO6BPAk4JSycrj5
9tC9sL4FnIAbAHmOSILCyGyyaBAcmiyH/3toYqXyjJkK+vbWQSTxk2NlqJLIN/ypLJ1pYffVZGUs
52g1hlQtHhgLIznB1Qx3Fop3nOUk8nNpQLON/aM8K5sl18964c7aXh7YZnalUQv3md4p2rAQQqIR
rZ8HBc7YjlZynwOnZl1NrK4cP5aM9lMkbfRGIUitHTIhoDYp8IZ1dwIDAQABo4IB3jCCAdowDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAoBgNVHREEITAfgR1ib3Jpcy5zdWtob2xpdGtvQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUtBmGs9S4
t1FcFSfkrP2LKQQwBKMwDQYJKoZIhvcNAQELBQADggEBAJMAjVBkRmr1lvVvEjMaLfvMhwGpUfh6
CMZsKICyz/ZZmvTmIZNwy+7b9r6gjLCV4tP63tz4U72X9qJwfzldAlYLYWIq9e/DKDjwJRYlzN8H
979QJ0DHPSJ9EpvSKXob7Ci/FMkTfq1eOLjkPRF72mn8KPbHjeN3VVcn7oTe5IdIXaaZTryjM5Ud
bR7s0ZZh6mOhJtqk3k1L1DbDTVB4tOZXZHRDghEGaQSnwU/qxCNlvQ52fImLFVwXKPnw6+9dUvFR
ORaZ1pZbapCGbs/4QLplv8UaBmpFfK6MW/44zcsDbtCFfgIP3fEJBByIREhvRC5mtlRtdM+SSjgS
ZiNfUggxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgw0
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMz7lU0GDbjs/8LQ
hCh/av1D05aXahwlJAnTWBKraXh8MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIxMDgzMDA5NDI0OFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCOVnjl/h/gmx4d588qicU234X6+KfSHEK7
W9zzGnFe6pt4KbJRg3EloPCdH7xfQYlZeupmltp6KKZ9dNTdBIW0FSxkt47Ev8/nZ4iWFBsc4qBE
p4179uADjHIbWr1G4qCPNFlX1gl7R0edaX9zvJTFhaDzPKRub9FVGIOEb06hTLyrbHe2+d49YCvQ
UW2zFgyWFZBJjg/8+uHtQjsEKRL3Z21RUXbPvivUUje/j1T7qx7C4g55Ci67muwe72ThCeekFTD4
a28+MG13xs5mU4pbELqwIv+uxSdgnWhV0ZptSlNotDqM06FJ7DeV4+2ozEQDvxxR2CyUJ0sqaT8u
qlsE
--000000000000ee8b2305cac3a773--
