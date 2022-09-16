Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5995D5BB260
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 20:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiIPSqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 14:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiIPSqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 14:46:10 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F176B81F8
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 11:46:09 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id z13so18817100edb.13
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 11:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=V00aPDgAVb5ryVWEIiab+qMajdMMrTMNmPKLDV+PTW4=;
        b=ILdP9jAsIgapu1Zy6mm79MgRBCf2+MzWhM0q+Y6MKKzCTRZ1M5ejMwz4/jiWuh5SEB
         GPcJO8YNM7QtznmwBrkK8HmN0LtOi4yRx2ilDssR07xUE8Ym5x8hv47ZCmPTwG48fQk9
         NgMdoQiWFwYJEFxcJEdpPF2IvrxwTEDkE6xxc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=V00aPDgAVb5ryVWEIiab+qMajdMMrTMNmPKLDV+PTW4=;
        b=49mL76lMRjHUSvhBexePeT+zHqedSQrEVgNTl3lMBcflOdZBj4L1FHnUMGEPt/OOxc
         wSwQO8/bx+4/tRT+kzlmvHTowkHVJxQOZLLDMhLZv6fwAPGSTpeKdZ0VODizVkt7Mo/S
         ypJ0s/S0aFnEb35et41GMcgPnCThQ9yH6E/H+qIw5VllgzehuAQ+jRV0QhEp3zin9YAa
         +iQkPQQb60p/EfpSfHwRm1MoMAqSKbhV7/JMWuJOor31Q4IpSo8Oyw8sCCjR6HGIqRr9
         FEd5EicRxIqaZzvVZWWS7gvkT3hJ1Ns7pYUnEwxZyQ5ANMNRfO5bbhjwOfdmXukHvK2W
         hkJg==
X-Gm-Message-State: ACrzQf0+xgu7j/EcLmy8cmQlG947wUfpNL6kDLSW6YJWyb8lxfxYUQNr
        rrITRAjG7qyd3eGXPFScgQMstmdpoiLeMn05GkMOJ9PAqvgeyA==
X-Google-Smtp-Source: AMsMyM52y32jXwANOiOsDGfJBaZB2RFQSNx/ATxMIGSRSno9rSVFyMCIakpyzS9PzjrbOE9eTHFnd56P/OFAM9xkg2w=
X-Received: by 2002:a50:c042:0:b0:44e:7582:366 with SMTP id
 u2-20020a50c042000000b0044e75820366mr4951389edd.235.1663353967577; Fri, 16
 Sep 2022 11:46:07 -0700 (PDT)
MIME-Version: 1.0
References: <PH0PR18MB4021AF3BD0091453908A44EA81489@PH0PR18MB4021.namprd18.prod.outlook.com>
 <PH0PR18MB402161E5489BC47F30FF681E81489@PH0PR18MB4021.namprd18.prod.outlook.com>
In-Reply-To: <PH0PR18MB402161E5489BC47F30FF681E81489@PH0PR18MB4021.namprd18.prod.outlook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 16 Sep 2022 11:45:56 -0700
Message-ID: <CACKFLikGdN9XPtWk-fdrzxdcD=+bv-GHBvfVfSpJzHY7hrW39g@mail.gmail.com>
Subject: Re: tg3 (5720) PTP sync problems
To:     Simon White <Simon.White@viavisolutions.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Stephen Hill <Stephen.Hill@viavisolutions.com>,
        Netdev <netdev@vger.kernel.org>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000064083105e8cfc6c7"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000064083105e8cfc6c7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

CC netdev instead of lkml and converting to plain text email

On Fri, Sep 16, 2022 at 8:54 AM Simon White
<Simon.White@viavisolutions.com> wrote:
>
> In a running setup PTP sync problems were observed when the server provid=
ing the PTP grand master performed other high load network transmissions.  =
Sync errors ranging in the 10s of milli seconds could be experienced by the=
 PTP slaves.

Thanks for reporting the issue.  One of my colleagues will look into this.

>
>
>
> Simplifying the setup and test conditions to two servers (Dell R7527 dual=
 socket servers with 64 core Milans) utilising iperf, we were able to repli=
cate the problem.  Multiple TX rings were tried, where the PTP traffic only=
 was given its own TX ring and set to use a high priority, however that mad=
e no difference.  Examination of the problem led to the following code:
>
>
>
> static void tg3_tx(struct tg3_napi *tnapi)
>
> {
>
> [snip]
>
>                 if (tnapi->tx_ring[sw_idx].len_flags & TXD_FLAG_HWTSTAMP)=
 {
>
>                         struct skb_shared_hwtstamps timestamp;
>
>                         u64 hwclock =3D tr32(TG3_TX_TSTAMP_LSB);
>
>                         hwclock |=3D (u64)tr32(TG3_TX_TSTAMP_MSB) << 32;
>
>
>
>                         tg3_hwclock_to_timestamp(tp, hwclock, &timestamp)=
;
>
>
>
>                         skb_tstamp_tx(skb, &timestamp);
>
>                 }
>
>
>
> This assumes that the timestamp will have been updated by the time this d=
escriptor in the tx ring has been marked as consumed.  We observe when the =
interface is under TX load that this nolonger holds true.  Changing tg3_sta=
rt_xmit to record the timestamp where TXD_FLAG_HWTSTAMP is set and spinning=
 in the above code to ensure the timestamp had updated appears to address t=
he PTP delay calculation.  A patch covering the change described has been a=
ttached for reference but am not suggesting it as the solution to the probl=
em.
>
>
>
> Adding printks to record the spinning loop duration showed it could take =
around 150us for the timestamp to update after the descriptor was marked as=
 being consumed.  It can be speculated how this could come about from BCM57=
18 Family Programmer=E2=80=99s Reference Guide (broadcom.com) figure 30 (Tr=
ansmit Flow Diagram) on page 132, however could it be confirmed whether the=
 assumption the tg3.c code makes is correct?
>
>
>
> Part:
>
>
>
> [   24.311626] tg3 0000:e1:00.0 eth0: Tigon3 [partno(BCM95720) rev 572000=
0] (PCI Express) MAC address xxxxxx
>
> [   24.311630] tg3 0000:e1:00.0 eth0: attached PHY is 5720C (10/100/1000B=
ase-T Ethernet) (WireSpeed[1], EEE[1])
>
>
>
> Kind Regards,
>
> Simon White

--00000000000064083105e8cfc6c7
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
OnaLEot1MoQO7BIe5S9H4AcCEXXcrJJiAtMCl47ARpyHmvQFQFFTrHgUYEd9V+9bOzY7MBIGSV1N
/JfsT1sZw6HT0lJkSQefhPGpBniAob62DJP3qr11tu8CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU31rAyTdZweIF0tJTFYwfOv2w
L4QwDQYJKoZIhvcNAQELBQADggEBACcuyaGmk0NSZ7Kio7O7WSZ0j0f9xXcBnLbJvQXFYM7JI5uS
kw5ozATEN5gfmNIe0AHzqwoYjAf3x8Dv2w7HgyrxWdpjTKQFv5jojxa3A5LVuM8mhPGZfR/L5jSk
5xc3llsKqrWI4ov4JyW79p0E99gfPA6Waixoavxvv1CZBQ4Stu7N660kTu9sJrACf20E+hdKLoiU
hd5wiQXo9B2ncm5P3jFLYLBmPltIn/uzdiYpFj+E9kS9XYDd+boBZhN1Vh0296zLQZobLfKFzClo
E6IFyTTANonrXvCRgodKS+QJEH8Syu2jSKe023aVemkuZjzvPK7o9iU7BKkPG2pzLPgxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxeQGjDntHGb2iaQkIw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIElOOUBzZfVn++vR9X5yyfTnOo544hmx
MdI0pwTewuSrMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDkx
NjE4NDYwN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAoEEQhycQ4Kqc/AJOTtabCmthTuZ2H2zr7bs9/0ZXNPJnAtdL2
xAVAAiSMZzo1gzW+6M28a8wgqEfyK58N6zFVo7IXRTj/bxfLBo6Mb1AIXmMi/OfqhYcjFcEVlsaA
O1MhTXw02xrqUeCDxZxAFNwL1CsmGQluSAfJE53f3XJmoX11OaliDsrFRz7XAJ4OgjhQAhXlPAiW
/EVq24k1sle0wfNrgDCeg+9puIh2RlCSAlcqXWMINFYMTUL02wwMVWW0+G2qRFV+rOWNXTwl8Igk
5OO/cYn1NUg2UFEVnHqQddXVfQqHSg8E2Tr5B+oT0YuQ66OEd8BveJhgV+unFFlC
--00000000000064083105e8cfc6c7--
